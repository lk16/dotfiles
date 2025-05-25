#!/usr/bin/env python

import click
from commands.global_git import global_git_status
from commands.tmux_broadcast import tmux_broadcast
from commands.tmux_statusbar import tmux_statusbar


@click.group()
def cli() -> None:
    pass


cli.add_command(tmux_statusbar)
cli.add_command(tmux_broadcast)
cli.add_command(global_git_status)

if __name__ == "__main__":
    cli()
