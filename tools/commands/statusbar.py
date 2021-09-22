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
from helpers.path import NOTES_ROOT_FOLDER

CONFIG_FILE = NOTES_ROOT_FOLDER / "tools/statusbar_conf.json"

NEVER_EXPIRES = -1


class SkipItemException(Exception):
    pass


class StatusBarItem(object):
    def __init__(self, config: Dict[str, Any]) -> None:
        self.config = config

    def expiry(self) -> int:
        return NEVER_EXPIRES

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
                percentage = round(float(line.split(" ")[-1][:-1]))
                return f"{percentage}%"

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


STATUSBAR_ITEMS: Dict[str, Type[StatusBarItem]] = {
    "battery": Battery,
    "date": Date,
    "spotify": Spotify,
    "weather": Weather,
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
def get_statusbar() -> None:
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

        if expiry != NEVER_EXPIRES:
            next_expiry = int(time.time()) + expiry
            if error:
                cache[item] = {"expiry": next_expiry, "text": "", "error": True}
            else:
                cache[item] = {"expiry": next_expiry, "text": text}

        header = COLOR_HEADERS[len(statusbar) % len(COLOR_HEADERS)]
        statusbar.append(f"{header} {text} ")

    store_cache("statusbar", cache)
    print("".join(statusbar))
