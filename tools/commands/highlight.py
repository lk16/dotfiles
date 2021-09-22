import sys

import click
from helpers.color import colorize_text


@click.command()
@click.option("-r", "--red", type=str)
@click.option("-g", "--green", type=str)
@click.option("-y", "--yellow", type=str)
@click.option("-b", "--blue", type=str)
@click.option("-p", "--purple", type=str)
@click.option("-c", "--cyan", type=str)
@click.option("-w", "--white", type=str)
def highlight(**kwargs):
    for line in sys.stdin:
        for color, text in kwargs.items():
            if text:
                line = line.replace(text, colorize_text(text, color))
        print(line, end="")
