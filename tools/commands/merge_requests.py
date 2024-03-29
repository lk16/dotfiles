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

    ticket = split_branch[1]
    title_parts = split_branch[2:]

    if not any([ticket == "noticket", ticket.isnumeric()]):
        print('Expected branch to have ticket number or "noticket" as second part')

    title = title_parts[0].title() + " "
    title += " ".join(title_part.lower() for title_part in title_parts[1:])

    prefix = ""

    if wip:
        prefix = "Draft: "

    maybe_hash_char = ""

    if ticket.isnumeric():
        maybe_hash_char = "#"

    command = f"glab mr create -t '{prefix}[{maybe_hash_char}{ticket}] {title}' --fill --yes --remove-source-branch"

    try:
        output = run_command(command)
        print(output)
    except CalledProcessError as e:
        if "could not find any commits between" in str(e.stderr):
            print("Creating MR failed: no commits between source and target branch.")
            exit(1)
        print("Creating MR failed.")
        print(f"stdout: {e.stdout.decode()}")
        print(f"stderr: {e.stderr.decode()}")
        exit(1)
    except Exception as e:
        print("Creating MR failed.")
        print(f"error: {e}")
        exit(1)

    if web:
        run_command("glab mr view --web")
