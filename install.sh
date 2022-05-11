#!/bin/bash

# -------- bootstrap --------

DOTFILES_ROOT=$(cd $(dirname $(realpath $0)); pwd)

if ! which "virtualenv" > /dev/null; then
    echo "Could not find executable virtualenv"
    echo "Consider running: sudo apt-get install python3-virtualenv"
    exit 1
fi

if ! which "python3" > /dev/null; then
    echo "Could not find executable python3"
    echo "Consider running: sudo apt-get install python-is-python3"
    exit 1
fi

# -------- create symlinks --------

# bash
ln -s $DOTFILES_ROOT/dotfiles/bash/rc.sh ~/.bashrc
ln -s $DOTFILES_ROOT/dotfiles/bash/profile.sh ~/.profile

# direnv
ln -s $DOTFILES_ROOT/dotfiles/direnv/rc.sh ~/.direnvrc

# git
ln -s $DOTFILES_ROOT/dotfiles/git/config.ini ~/.gitconfig
ln -s $DOTFILES_ROOT/dotfiles/git/ignore ~/.gitignore

# tmux
ln -s $DOTFILES_ROOT/dotfiles/tmux/config.tmux ~/.tmux.conf

# vscode config
ln -s $DOTFILES_ROOT/dotfiles/vscode/config.json ~/.config/Code/User/settings.json

# -------- setup global git ignore --------

git config --global core.excludesfile ~/.gitignore

# -------- setup tmux config --------

# copy default tmux toolbar conf
cp -n $DOTFILES_ROOT/tools/statusbar_conf.json.default $DOTFILES_ROOT/tools/statusbar_conf.json

# install tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# -------- setup tools --------

cd $DOTFILES_ROOT/tools
virtualenv -q -p `which python3` venv
. venv/bin/activate
pip install -q -r requirements.txt

if [ ! -f $(git rev-parse --show-toplevel)/.git/hooks/pre-commit ]; then
    pre-commit install
fi

# ------- check installed common binaries --------

echo -e "\nChecking exteneral dependencies of notes repo:"
./manage.py check-external-dependencies

echo -e "\nChecking common tools:"
./manage.py check-common-tools

echo -e "\nChecking multimedia:"
./manage.py check-multimedia

echo -e "\nChecking VS Code extensions:"
./manage.py vscode-extensions status
