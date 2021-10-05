from pathlib import Path
from typing import List

import click

IGNORED_FOLDERS = ["venv", ".venv"]


def contains_python_file(path: Path) -> bool:
    for file in path.iterdir():
        if file.is_file() and file.suffix == ".py":
            return True
        if file.is_dir() and contains_python_file(file):
            return True

    return False


def has_missing_init_file(path: Path) -> bool:
    return contains_python_file(path) and not (path / "__init__.py").exists()


def find_mising_init_files(path: Path) -> List[Path]:
    # TODO this naive algorithm is very inefficient
    missing_init_files: List[Path] = []

    if has_missing_init_file(path):
        missing_init_files.append(path / "__init__.py")

    for file in path.iterdir():
        if file.is_dir() and file.name not in IGNORED_FOLDERS:
            missing_init_files += find_mising_init_files(file)

    return missing_init_files


@click.command()
@click.argument("root_folder", type=str)
@click.option("--create", "-c", is_flag=True)
def find_missing_init(root_folder: str, create: bool):

    missing_init_files: List[Path] = []

    for file in Path(root_folder).iterdir():
        if file.is_dir() and file.name not in IGNORED_FOLDERS:
            missing_init_files += find_mising_init_files(file)

    if create:
        for file in sorted(missing_init_files):
            file.touch(mode=0o644)
        print(f"Created {len(missing_init_files)} missing __init__.py files.")
        return

    for file in sorted(missing_init_files):
        print(file.resolve())

    print(f"Found {len(missing_init_files)} missing __init__.py files.")

    if missing_init_files:
        exit(1)
