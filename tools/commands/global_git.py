import click
from helpers.color import colorize_text
from helpers.command import run_command


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
