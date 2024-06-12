#!/bin/bash

[ -d ~/.pyenv/bin ] && PATH=$PATH:~/.pyenv/bin
[ -d ~/.poetry/bin ] && PATH=$PATH:~/.poetry/bin

if which pyenv > /dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

# force colored output of pytest
export PYTEST_ADDOPTS="--color=yes"

# force colored output of mypy
export MYPY_FORCE_COLOR=1

# disable unreadable Typer stacktrace
    export _TYPER_STANDARD_TRACEBACK=1
