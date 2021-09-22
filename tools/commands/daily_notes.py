import re
from datetime import datetime
from pathlib import Path
from typing import List

import click
from helpers.path import NOTES_ROOT

DAILY_NOTES_FOLDER = NOTES_ROOT / "work/daily"
DAILY_NOTES_REGEX = re.compile(r"^\d{4}-\d{2}-\d{2}\.md$")
DAILY_NOTES_SHORTCUT = DAILY_NOTES_FOLDER / "today.md"


def copy_notes(todays_notes_path: Path) -> None:
    if todays_notes_path.exists():
        print(f"Today's notes already exist: {todays_notes_path}")
        return

    files: List[Path] = sorted(
        filter(
            lambda path: re.match(DAILY_NOTES_REGEX, path.name),
            DAILY_NOTES_FOLDER.iterdir(),
        )
    )

    if not files:
        print(f"No older files found in {DAILY_NOTES_FOLDER}")
        exit(1)

    last_notes_path: Path = files[-1]

    with last_notes_path.open("r") as last_notes:
        with todays_notes_path.open("w") as todays_notes:
            # write current date
            todays_notes.write("# " + datetime.now().strftime("%Y-%m-%d") + "\n")

            # discard date of last notes
            next(last_notes)

            for line in last_notes:
                todays_notes.write(line)

    print(f"Created {todays_notes_path}")


def update_symllink(todays_notes_path: Path) -> None:
    DAILY_NOTES_SHORTCUT.unlink(missing_ok=True)
    DAILY_NOTES_SHORTCUT.symlink_to(todays_notes_path)

    print(f"Created/updated symlink {DAILY_NOTES_SHORTCUT}")


@click.command()
def new_daily_notes():
    if datetime.now().weekday() in [5, 6]:
        print("No new notes file created, it's weekend.")
        return

    todays_notes_path = DAILY_NOTES_FOLDER / datetime.now().strftime("%Y-%m-%d.md")

    copy_notes(todays_notes_path)
    update_symllink(todays_notes_path)
