import json
from typing import Any

from helpers.path import DOTFILES_ROOT

CACHE_ROOT = DOTFILES_ROOT / "tools/.cache"


def load_cache(name: str, default: Any) -> Any:
    CACHE_ROOT.mkdir(exist_ok=True)

    try:
        file = open(CACHE_ROOT / f"{name}.json", "r")
    except FileNotFoundError:
        return default
    return json.load(file)


def store_cache(name: str, data: Any) -> Any:
    CACHE_ROOT.mkdir(exist_ok=True)

    file = open(CACHE_ROOT / f"{name}.json", "w")
    return json.dump(data, file)
