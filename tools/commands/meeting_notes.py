import re
from datetime import date, timedelta

import click
from helpers.path import NOTES_ROOT

MEETING_NOTES_FOLDER = NOTES_ROOT / "work/meetings"
DAILY_FILES_REGEX = re.compile(r"^(\d{4})-(\d{2})-(\d{2}).*$")

MAX_DAILY_NOTES_AGE = timedelta(days=7)


@click.command()
def archive_meeting_files():
    archived_notes = 0

    for file in MEETING_NOTES_FOLDER.iterdir():
        m = DAILY_FILES_REGEX.search(file.name)

        if not m:
            continue

        year = int(m.group(1))
        month = int(m.group(2))
        day = int(m.group(3))

        file_date = date(year, month, day)

        age = date.today() - file_date

        if age > MAX_DAILY_NOTES_AGE:
            archive_folder = MEETING_NOTES_FOLDER / f"{year}/{month:02}"
            archive_folder.mkdir(mode=0o744, parents=True, exist_ok=True)
            file.rename(archive_folder / file.name)
            archived_notes += 1

    if archived_notes > 0:
        print(f"Archived {archived_notes} file(s).")
