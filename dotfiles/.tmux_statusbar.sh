#!/bin/bash
source ~/.bashrc
cd $NOTES_ROOT_FOLDER/tools
source ./venv/bin/activate
./manage.py get-statusbar
