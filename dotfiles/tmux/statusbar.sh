#!/bin/bash

# Folder this script lives in.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ~/.bashrc
cd $SCRIPT_DIR/../../tools
source ./venv/bin/activate
/usr/bin/python3 ./manage.py tmux-statusbar
