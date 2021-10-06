import os
from functools import lru_cache
from pathlib import Path
from subprocess import CalledProcessError
from typing import List

import click
from helpers.command import run_command


@lru_cache(maxsize=None)
def contains_python_file(folder: Path) -> bool:
    for file in folder.iterdir():
        if file.is_file() and file.suffix == ".py":
            return True
        if file.is_dir() and contains_python_file(file):
            return True

    return False


@click.command()
@click.argument("root_folder", type=str)
@click.option("--create", "-c", is_flag=True)
def find_missing_init(root_folder: str, create: bool):

    os.chdir(root_folder)

    try:
        run_command("git rev-parse --show-toplevel 2>/dev/null")
    except CalledProcessError:
        print(f"This is not a git repository: {root_folder}")
        exit(1)

    # get absolute path of all non-root folders with git-tracked files
    folders_raw = run_command(
        r"git ls-files | xargs -n 1 dirname | sort | uniq | grep -v '^\.$' | xargs realpath"
    )
    folders = [Path(folder) for folder in folders_raw]

    missing_init_files: List[Path] = []

    for folder in folders:
        init_path = folder / "__init__.py"
        if not init_path.exists() and contains_python_file(folder):
            missing_init_files.append(init_path)

    if create:
        for file in missing_init_files:
            file.touch(mode=0o644)
        print(f"Created {len(missing_init_files)} missing __init__.py files.")
        return

    for file in sorted(missing_init_files):
        print(file.resolve())

    print(f"Found {len(missing_init_files)} missing __init__.py files.")

    if missing_init_files:
        exit(1)
