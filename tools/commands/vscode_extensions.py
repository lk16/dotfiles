import subprocess
from typing import List

import click
from click.exceptions import ClickException
from helpers.color import colorize_text
from helpers.path import DOTFILES_ROOT

VSCODE_EXTENSIONS_PATH = DOTFILES_ROOT / "dotfiles/.vscode_extensions.txt"


@click.group()
def vscode_extensions():
    pass


def _get_installed_extensions() -> List[str]:
    process = subprocess.Popen(
        ["code", "--list-extensions"], stdout=subprocess.PIPE, stderr=subprocess.PIPE
    )
    stdout, stderr = process.communicate()

    if process.returncode != 0:
        raise ClickException(f"Failed getting extensions: {stderr.decode('utf-8')}")

    return stdout.decode("utf-8").strip().split("\n")


def _get_notes_extensions() -> List[str]:
    if not VSCODE_EXTENSIONS_PATH.exists():
        return []

    with open(VSCODE_EXTENSIONS_PATH, "r") as file:
        return file.read().strip().split("\n")


def _install_extension(extension: str) -> None:
    process = subprocess.Popen(
        ["code", "--install-extension", extension],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    _, stderr = process.communicate()

    if process.returncode != 0:
        raise ClickException(f"Failed getting extensions: {stderr.decode('utf-8')}")


def _show_status() -> None:
    installed_extensions = _get_installed_extensions()
    notes_extensions = _get_notes_extensions()

    extensions = set(installed_extensions + notes_extensions)

    for extension in sorted(extensions):
        print(f"{extension:>60}: ", end="")

        if extension in installed_extensions:
            if extension in notes_extensions:
                print(colorize_text("INSTALLED", "green"))
            else:
                print(colorize_text("NOT IN NOTES", "red"))
        else:
            print(colorize_text("NOT INSTALLED YET", "red"))


@vscode_extensions.command()
def status() -> None:
    _show_status()


@vscode_extensions.command()
def save() -> None:
    installed_extensions = _get_installed_extensions()
    notes_extensions = _get_notes_extensions()

    if set(notes_extensions) - set(installed_extensions):
        print("Save was prevented. Either:")
        print(f"- remove extensions from {VSCODE_EXTENSIONS_PATH}")
        print(f"- run ./manage.py vscode-extensions install")
        print()

        _show_status()
        exit(1)

    with open(VSCODE_EXTENSIONS_PATH, "w") as file:
        for extension in installed_extensions:
            file.write(extension + "\n")


@vscode_extensions.command()
def install() -> None:
    installed_extensions = _get_installed_extensions()
    notes_extensions = _get_notes_extensions()

    new_extensions = set(notes_extensions) - set(installed_extensions)

    for extension in new_extensions:
        _install_extension(extension)

    print(f"Installed {len(new_extensions)} extensions")
