#!/usr/bin/env python

import click
from commands.check_dependencies import (
    check_common_tools,
    check_external_dependencies,
    check_multimedia,
)
from commands.csvcut import csvcut
from commands.find_missing_init import find_missing_init
from commands.global_git import global_git_status
from commands.highlight import highlight
from commands.meeting_notes import archive_meeting_files
from commands.merge_requests import create_merge_request
from commands.tmux_broadcast import tmux_broadcast
from commands.tmux_statusbar import tmux_statusbar
from commands.vscode_extensions import vscode_extensions


@click.group()
def cli() -> None:
    pass


cli.add_command(check_common_tools)
cli.add_command(check_external_dependencies)
cli.add_command(check_multimedia)
cli.add_command(csvcut)
cli.add_command(find_missing_init)
cli.add_command(tmux_statusbar)
cli.add_command(highlight)
cli.add_command(archive_meeting_files)
cli.add_command(tmux_broadcast)
cli.add_command(vscode_extensions)
cli.add_command(create_merge_request)
cli.add_command(global_git_status)

if __name__ == "__main__":
    cli()
