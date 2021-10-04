import datetime
import json
import re
import subprocess
import sys
import time
import traceback
from typing import Any, Dict, List, Type

import click
import requests
from helpers.cache import load_cache, store_cache
from helpers.path import DOTFILES_ROOT

CONFIG_FILE = DOTFILES_ROOT / "tools/statusbar_conf.json"

EXPIRES_IMMIEDIATELY = -1


class SkipItemException(Exception):
    pass


class StatusBarItem(object):
    def __init__(self, config: Dict[str, Any]) -> None:
        self.config = config

    def expiry(self) -> int:
        return EXPIRES_IMMIEDIATELY

    def get_text(self) -> str:
        raise NotImplementedError


class Battery(StatusBarItem):
    def get_text(self) -> str:
        command = ["acpitool", "-B"]

        try:
            process = subprocess.run(
                command, stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
        except FileNotFoundError as e:
            raise SkipItemException("acpitool is not installed") from e

        output = process.stdout.decode("utf-8").split("\n")

        marker = "Remaining capacity"

        for line in output:
            if marker in line:
                percentage_raw = next(item for item in line.split(" ") if "%" in item)
                percentage = float(percentage_raw.strip("%,"))
                return f"{percentage:.0f}%"

        raise ValueError(f'Marker "{marker}" not found')


class Date(StatusBarItem):
    def get_text(self) -> str:
        return datetime.datetime.now().strftime("%Y-%m-%d %H:%M")


class Weather(StatusBarItem):
    def expiry(self) -> int:
        return 60

    def get_text(self):
        location = self.config["location"]
        api_key = self.config["api_key"]

        r = requests.get(
            f"https://api.openweathermap.org/data/2.5/weather?q={location}&APPID={api_key}&units=metric"
        )

        r.raise_for_status()

        data = json.loads(r.text)

        temp = int(data["main"]["temp"])
        weather = list([item["main"] for item in data["weather"]])[0]

        return f"{temp}°C {weather}"


class Spotify(StatusBarItem):
    def get_text(self) -> str:
        command = [
            "dbus-send",
            "--print-reply",
            "--dest=org.mpris.MediaPlayer2.spotify",
            "/org/mpris/MediaPlayer2",
            "org.freedesktop.DBus.Properties.Get",
            "string:org.mpris.MediaPlayer2.Player",
            "string:Metadata",
        ]
        process = subprocess.run(
            command, stdout=subprocess.PIPE, stderr=subprocess.PIPE
        )

        if process.returncode != 0:
            raise SkipItemException

        output = process.stdout.decode("utf-8").replace("\n", "")

        artist_match = re.search('string "xesam:artist".*?string "(.*?)"', output)
        title_match = re.search('string "xesam:title".*?string "(.*?)"', output)

        if not (artist_match and title_match):
            print("Spotify regex failed", file=sys.stderr)
            raise SkipItemException

        return "{} / {}".format(artist_match.group(1), title_match.group(1))


class MachineStats(StatusBarItem):
    def get_empty_disk_space(self) -> str:
        process = subprocess.Popen(
            ["df", "--output=avail", "-h", "/"],
            stderr=subprocess.DEVNULL,
            stdout=subprocess.PIPE,
        )
        stdout, _ = process.communicate()
        return stdout.decode("utf-8").strip().split("\n")[1].strip()

    def get_free_memory(self) -> str:
        free_memory_line = ""

        with open("/proc/meminfo", "r") as meminfo:
            for line in meminfo:
                if "MemFree:" in line:
                    free_memory_line = line

        free_memory_kb = next(
            int(word) for word in free_memory_line.split(" ") if word.isdigit()
        )

        free_memory_mb = free_memory_kb / 1024
        free_memory_gb = free_memory_mb / 1024

        if free_memory_gb > 2:
            return f"{int(free_memory_gb)}G"

        return f"{int(free_memory_mb)}M"

    def get_cpu_usage(self) -> str:
        process = subprocess.Popen(
            ["top", "-bn", "1"], stderr=subprocess.DEVNULL, stdout=subprocess.PIPE
        )
        stdout, _ = process.communicate()
        stats_line = stdout.decode("utf-8").strip().split("\n")[2]

        cpu_idle_section = stats_line.split(", ")[3]

        try:
            cpu_idle = float(cpu_idle_section.split(" ")[0].replace(",", "."))
            cpu_busy = int(100 - cpu_idle)
        except Exception:
            # TODO
            cpu_busy = 0

        return f"{cpu_busy: 3}%"

    def get_text(self) -> str:
        disk = self.get_empty_disk_space()
        memory = self.get_free_memory()
        cpu = self.get_cpu_usage()

        return f"Cpu{cpu} | Mem {memory} | Disk {disk}"


STATUSBAR_ITEMS: Dict[str, Type[StatusBarItem]] = {
    "battery": Battery,
    "date": Date,
    "spotify": Spotify,
    "weather": Weather,
    "machine_stats": MachineStats,
}

COLOR_HEADERS = [
    "#[bg=colour238]#[fg=colour11]",
    "#[bg=colour233]#[fg=colour11]",
]


def get_statusbar_item_text(
    item: str, status_bar_item: StatusBarItem, cache_item: Dict[str, Any]
) -> str:
    if "error" in cache_item:
        print(f"Found error marker in cache for {item}", file=sys.stderr)
        raise SkipItemException

    if cache_item and (cache_item["expiry"] < int(time.time())):
        print(f"Loaded {item} from cache", file=sys.stderr)
        return cache_item["text"]

    print(f"Running {item}", file=sys.stderr)
    return status_bar_item.get_text()


@click.command()
def tmux_statusbar() -> None:
    config = json.load(open(CONFIG_FILE, "r"))

    cache = load_cache("statusbar", {})
    items = config["statusbar"]["items"]

    statusbar: List[str] = []

    for item in items:
        cache_item = cache.get(item, {})

        if "error" in cache_item:
            print(f"Found error marker in cache for {item}", file=sys.stderr)
            continue

        item_config = config.get(item)
        status_bar_item = STATUSBAR_ITEMS[item](item_config)
        error = False

        try:
            text = get_statusbar_item_text(item, status_bar_item, cache_item)
        except SkipItemException:
            print(f"Skipping {item}", file=sys.stderr)
            continue
        except Exception:
            traceback.print_exc(file=sys.stderr)
            error = True
            continue

        expiry = status_bar_item.expiry()

        if expiry != EXPIRES_IMMIEDIATELY:
            next_expiry = int(time.time()) + expiry
            if error:
                cache[item] = {"expiry": next_expiry, "text": "", "error": True}
            else:
                cache[item] = {"expiry": next_expiry, "text": text}

        header = COLOR_HEADERS[len(statusbar) % len(COLOR_HEADERS)]
        statusbar.append(f"{header} {text} ")

    store_cache("statusbar", cache)
    print("".join(statusbar))
