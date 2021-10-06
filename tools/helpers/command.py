import subprocess
from typing import List


def run_command(command: str) -> List[str]:
    process = subprocess.run(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True
    )

    return process.stdout.decode("utf-8").strip().split("\n")
