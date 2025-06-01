#!/bin/bash

# Folder this script lives in.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd $SCRIPT_DIR/../../tools
rye run tmux-statusbar
