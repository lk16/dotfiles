from typing import List, Tuple


def print_row(items: List[str], widths: List[int]):
    resized_items: List[str] = []

    for item, width in zip(items, widths):
        if len(item) > width:
            resized_item = item[: width - 1] + "…"
        else:
            format_str = f"{{:<{width}}}"
            resized_item = format_str.format(item)

        resized_items.append(resized_item)

    print(" ".join(resized_items))


def print_table(
    columns: List[Tuple[str, int]], rows: List[List[str]], show_headers=True
):
    widths = [c[1] for c in columns]
    headers = [c[0].upper() for c in columns]

    if show_headers:
        print_row(headers, widths)

    for i, row in enumerate(rows):
        if len(row) != len(columns):
            raise ValueError(
                f"Row at index {i} has {len(row)} columns, expected {len(columns)}."
            )
        print_row(row, widths)
