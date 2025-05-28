#!/bin/bash

# Folder this script lives in.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source ~/.bashrc
cd $SCRIPT_DIR/../../tools
source ./venv/bin/activate
./manage.py tmux-statusbar
