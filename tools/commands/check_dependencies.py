import subprocess
from typing import List

import click
from helpers.color import colorize_text

EXTERNAL_DEPENDENCIES = [
    "acpitool",
    "direnv",
    "mplayer",
    "pygmentize",
    "xclip",
    "xrandr",
]

COMMON_TOOLS = [
    "code",
    "docker",
    "docker-compose",
    "git",
    "go",
    "htop",
    "nano",
    "pre-commit",
    "poetry",
    "sudo",
    "tmux",
]


def check_dependencies(dependencies: List[str]) -> int:
    exit_code = 0

    for dependency in dependencies:
        which_exit_code = subprocess.call(
            ["which", dependency], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )
        print(f"{dependency:>15}: ", end="")
        if which_exit_code == 0:
            print(colorize_text("FOUND", "green"))
        else:
            print(colorize_text("MISSING", "red"))
            exit_code = 1

    return exit_code


@click.command()
def check_external_dependencies():
    exit_code = check_dependencies(EXTERNAL_DEPENDENCIES)
    exit(exit_code)


@click.command()
def check_common_tools():
    exit_code = check_dependencies(COMMON_TOOLS)
    exit(exit_code)
