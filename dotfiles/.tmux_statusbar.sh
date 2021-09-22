#!/bin/bash
source ~/.bashrc
cd $DOTFILES_ROOT/tools
source ./venv/bin/activate
./manage.py get-statusbar
