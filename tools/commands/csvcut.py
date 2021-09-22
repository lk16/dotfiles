import csv
import sys
from typing import List, Optional

import click
from click.exceptions import ClickException


def fields_to_list(fields: str, column_count: int) -> List[int]:
    field_list: List[int] = []
    for group in fields.split(","):
        split_group = group.split("-")

        if len(split_group) == 1:
            field_list.append(int(split_group[0]))

        elif len(split_group) == 2:
            if split_group[0] == "":
                start = 1
            else:
                start = int(split_group[0])

            if split_group[1] == "":
                end = column_count + 1
            else:
                end = int(split_group[1]) + 1

            field_list += list(range(start, end))

        else:
            # length > 2
            raise ValueError

    return field_list


@click.command()
@click.option("-f", "--fields", type=str)
@click.option("-d", "--delimiter", type=str)
def csvcut(fields: Optional[str], delimiter: str = " "):

    if fields is None:
        raise ClickException("-f/--fields is required")
        exit(1)

    csv_reader = csv.reader(sys.stdin, delimiter=delimiter)
    csv_writer = csv.writer(sys.stdout, delimiter=delimiter, quoting=csv.QUOTE_ALL)

    for line in csv_reader:
        fields_list = fields_to_list(fields, len(line))
        row = list(line[index - 1] for index in fields_list)
        csv_writer.writerow(row)
