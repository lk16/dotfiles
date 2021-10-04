import re
from datetime import date, datetime, timedelta
from pathlib import Path
from typing import List

import click
from helpers.path import NOTES_ROOT

DAILY_NOTES_FOLDER = NOTES_ROOT / "work/daily"
DAILY_NOTES_REGEX = re.compile(r"^\d{4}-\d{2}-\d{2}\.md$")
DAILY_FILES_REGEX = re.compile(r"^(\d{4})-(\d{2})-(\d{2}).*$")
DAILY_NOTES_SHORTCUT = DAILY_NOTES_FOLDER / "today.md"

MAX_DAILY_NOTES_AGE = timedelta(days=7)


def copy_last_notes(todays_notes_path: Path) -> None:
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


def update_symlink(todays_notes_path: Path) -> None:
    DAILY_NOTES_SHORTCUT.unlink(missing_ok=True)
    DAILY_NOTES_SHORTCUT.symlink_to(todays_notes_path)
    print(f"Created/updated symlink {DAILY_NOTES_SHORTCUT}")


def archive_old_notes():
    archived_notes = 0

    for file in DAILY_NOTES_FOLDER.iterdir():
        m = DAILY_FILES_REGEX.search(file.name)

        if not m:
            continue

        year = int(m.group(1))
        month = int(m.group(2))
        day = int(m.group(3))

        file_date = date(year, month, day)

        age = date.today() - file_date

        if age > MAX_DAILY_NOTES_AGE:
            archive_folder = DAILY_NOTES_FOLDER / f"{year}/{month:02}"
            archive_folder.mkdir(mode=0o744, parents=True, exist_ok=True)
            file.rename(archive_folder / file.name)
            archived_notes += 1

    if archived_notes > 0:
        print(f"Archived {archived_notes} file(s).")


@click.command()
def new_daily_notes():
    if datetime.now().weekday() in [5, 6]:
        print("No new notes file created, it's weekend.")
        return

    todays_notes_path = DAILY_NOTES_FOLDER / datetime.now().strftime("%Y-%m-%d.md")

    copy_last_notes(todays_notes_path)
    update_symlink(todays_notes_path)
    archive_old_notes()
