import datetime
import json
import re
import subprocess
import sys
import time
import traceback
from pathlib import Path
from typing import Any, cast

import click
import psutil
import requests

CONFIG_FILE = (Path(__file__).parent / "../../tools/statusbar_conf.json").resolve()
CACHE_ROOT = (Path(__file__).parent / "../../tools/.cache").resolve()

EXPIRES_IMMIEDIATELY = -1


def load_cache(name: str, default: Any) -> Any:
    CACHE_ROOT.mkdir(exist_ok=True)

    try:
        with open(CACHE_ROOT / f"{name}.json") as file:
            return json.load(file)
    except FileNotFoundError:
        return default


def store_cache(name: str, data: Any) -> Any:
    CACHE_ROOT.mkdir(exist_ok=True)

    with open(CACHE_ROOT / f"{name}.json", "w") as file:
        return json.dump(data, file)


class SkipItemException(Exception):
    pass


class StatusBarItem:
    def __init__(self, config: dict[str, Any]) -> None:
        self.config = config

    def expiry(self) -> int:
        return EXPIRES_IMMIEDIATELY

    def get_text(self) -> str:
        raise NotImplementedError


class Battery(StatusBarItem):
    def get_text(self) -> str:
        command = ["acpitool", "-B"]

        try:
            process = subprocess.run(command, capture_output=True, check=False)
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
        return datetime.datetime.now().strftime("%Y-%m-%d %H:%M")  # noqa: DTZ005 (local time is intentional)


class Weather(StatusBarItem):
    def expiry(self) -> int:
        return 60

    def get_text(self) -> str:
        location = self.config["location"]
        api_key = self.config["api_key"]

        r = requests.get(
            f"https://api.openweathermap.org/data/2.5/weather?q={location}&APPID={api_key}&units=metric"
        )

        r.raise_for_status()

        data = json.loads(r.text)

        temp = int(data["main"]["temp"])
        weather = next(item["main"] for item in data["weather"])

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
        process = subprocess.run(command, capture_output=True, check=False)

        if process.returncode != 0:
            raise SkipItemException

        output = process.stdout.decode("utf-8").replace("\n", "")

        artist_match = re.search('string "xesam:artist".*?string "(.*?)"', output)
        title_match = re.search('string "xesam:title".*?string "(.*?)"', output)

        if not (artist_match and title_match):
            print("Spotify regex failed", file=sys.stderr)
            raise SkipItemException

        return f"{artist_match.group(1)} / {title_match.group(1)}"


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
        virtual_mem = psutil.virtual_memory()

        # does not show memory used for cache
        free_memory_b = virtual_mem.total - virtual_mem.used
        free_memory_kb = free_memory_b / 1024
        free_memory_mb = free_memory_kb / 1024
        free_memory_gb = free_memory_mb / 1024

        if free_memory_gb > 2:
            return f"{int(free_memory_gb)}G"

        return f"{int(free_memory_mb)}M"

    def get_cpu_usage(self) -> str:
        cpu_usage = int(psutil.cpu_percent())

        return f"{cpu_usage: 3}%"

    def get_text(self) -> str:
        disk = self.get_empty_disk_space()
        memory = self.get_free_memory()
        cpu = self.get_cpu_usage()

        return f"Cpu{cpu} | Mem {memory} | Disk {disk}"


STATUSBAR_ITEMS: dict[str, type[StatusBarItem]] = {
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
    item: str, status_bar_item: StatusBarItem, cache_item: dict[str, Any]
) -> str:
    if "error" in cache_item:
        print(f"Found error marker in cache for {item}", file=sys.stderr)
        raise SkipItemException

    if cache_item and (cache_item["expiry"] < int(time.time())):
        print(f"Loaded {item} from cache", file=sys.stderr)
        return cast(str, cache_item["text"])

    print(f"Running {item}", file=sys.stderr)
    return status_bar_item.get_text()


@click.command()
def tmux_statusbar() -> None:
    with open(CONFIG_FILE) as file:
        config = json.load(file)

    cache = load_cache("statusbar", {})
    items = config["statusbar"]["items"]

    statusbar: list[str] = []

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
        except Exception:  # noqa: BLE001 (one bad item must not break the rest of the statusbar)
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


if __name__ == "__main__":
    tmux_statusbar()
