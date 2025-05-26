import subprocess
from typing import List

import click


def colorize_text(text: str, color: str) -> str:
    markers = {
        "red": "\033[1;31m",
        "green": "\033[1;32m",
        "yellow": "\033[1;33m",
        "blue": "\033[1;34m",
        "purple": "\033[1;35m",
        "cyan": "\033[1;36m",
        "white": "\033[1;37m",
        "reset": "\033[0m",
    }

    return "{}{}{}".format(markers[color], text, markers["reset"])


def run_command(command: str) -> List[str]:
    process: subprocess.CompletedProcess[bytes] = subprocess.run(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True
    )

    return process.stdout.decode("utf-8").strip().split("\n")


@click.command()
def global_git_status() -> None:
    git_repos = run_command(
        "find ~ -maxdepth 4 -name .git -type d -prune -exec dirname {} \\; | grep -v '/\\.' | sort"
    )

    dirty_repos = 0

    for git_repo in git_repos:
        branch_name = run_command(f"git -C {git_repo} rev-parse --abbrev-ref HEAD")[0]

        uncommited_files = run_command(f"git -C {git_repo} status -s")

        if uncommited_files != [""]:
            print(
                colorize_text(
                    f"{git_repo} @ {branch_name} has uncommitted files", "red"
                )
            )

            for uncommited_file in uncommited_files:
                print(uncommited_file.split()[1])
            print()
            dirty_repos += 1
            continue

        unpushed_branches = run_command(
            f"git -C {git_repo} branch -v | grep ahead || true"
        )

        if unpushed_branches != [""]:
            print(colorize_text(f"{git_repo} has unpushed branches", "red"))
            for unpushed_branch in unpushed_branches:
                print(unpushed_branch.replace("* ", "").split()[0])
            print()
            dirty_repos += 1

    if dirty_repos == 0:
        print(colorize_text(f"Checked {len(git_repos)} repositiories.", "green"))
    else:
        print(
            colorize_text(
                f"Checked {len(git_repos)} repositiories. Found {dirty_repos} dirty repositories.",
                "red",
            )
        )
        exit(1)
