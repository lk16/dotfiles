from getpass import getuser
from subprocess import CalledProcessError

import click
from helpers.command import run_command


@click.command()
@click.option("--wip", "-w", is_flag=True, default=False)
@click.option("--web", "-o", is_flag=True, default=False)
def create_merge_request(wip: bool, web: bool) -> None:

    try:
        run_command("glab mr view")
    except CalledProcessError:
        pass
    else:
        if web:
            run_command("glab mr view --web")
            return

        print("MR already exists.")
        exit(1)

    branch = run_command("git branch --show-current")[0]
    split_branch = branch.split("-")

    if split_branch[0] != getuser():
        print("Current branch doesn't start with username")
        exit(1)

    if len(split_branch) < 3:
        print("Expected branch to contain at least 2 dashes")
        exit(1)

    if split_branch[1] == "noticket":
        ticket = "noticket"
        title_parts = split_branch[2:]
    elif split_branch[2] == "noticket":
        ticket = "noticket"
        title_parts = split_branch[3:]
    else:
        ticket = "-".join(split_branch[1:3])
        title_parts = split_branch[3:]

    title = title_parts[0].title() + " "
    title += " ".join(title_part.lower() for title_part in title_parts[1:])

    prefix = ""

    if wip:
        prefix = "[WIP]"

    command = f"glab mr create -t '{prefix}[{ticket}] {title}' --fill --yes --remove-source-branch"
    run_command(command)

    if web:
        run_command("glab mr view --web")
        return
