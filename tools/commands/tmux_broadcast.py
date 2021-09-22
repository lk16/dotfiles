import os
import subprocess
from typing import List, Optional

import click
from click.exceptions import ClickException


def get_active_tmux_session() -> str:
    if "TMUX" not in os.environ:
        raise ClickException("When run outside of tmux use the -s flag.")

    process = subprocess.Popen(
        ["tmux", "display-message", "-p", "#S"], stdout=subprocess.PIPE
    )

    output = process.communicate()[0]

    if process.returncode != 0:
        raise ClickException("Failed to get tmux session id.")

    return output.decode("utf-8").strip()


def get_tmux_window_ids(session: str) -> List[str]:
    process = subprocess.Popen(
        ["tmux", "list-windows", "-t", session], stdout=subprocess.PIPE
    )

    output = process.communicate()[0]

    if process.returncode != 0:
        raise ClickException("Failed to get tmux window list.")

    output_lines = output.decode("utf-8").strip().split("\n")
    return [line.split(":")[0] for line in output_lines]


@click.command()
@click.option("-s", "--session", help="defaults to currently active session")
@click.argument("command")
def tmux_broadcast(session: Optional[str], command: str):

    if session is None:
        session = get_active_tmux_session()

    window_ids = get_tmux_window_ids(session)

    for window_id in window_ids:

        tmux_commands = [
            ["tmux", "setw", "-t", f"{session}:{window_id}", "synchronize-panes"],
            ["tmux", "send-keys", "-lt", f"{session}:{window_id}", command],
            ["tmux", "send-keys", "-t", f"{session}:{window_id}", "Enter"],
            [
                "tmux",
                "setw",
                "-t",
                f"{session}:{window_id}",
                "synchronize-panes",
                "off",
            ],
        ]

        for tmux_command in tmux_commands:
            process = subprocess.Popen(tmux_command, stdout=subprocess.PIPE)
            process.communicate()

            if process.returncode != 0:
                raise ClickException("Failed to get tmux window list.")
