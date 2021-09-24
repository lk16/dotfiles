#!/bin/bash

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

dotfiles=(
    ".bashrc"
    ".direnvrc"
    ".tmux.conf"
)

# make symlinks for dotfiles
for dotfile in "${dotfiles[@]}"; do
	ln -s $DOTFILES_ROOT/dotfiles/$dotfile ~/$dotfile
done

# make symlink for VS Code config separately because target file differs from symlink name
ln -s $DOTFILES_ROOT/dotfiles/.vscode.json ~/.config/Code/User/settings.json

# copy default tmux toolbar conf
cp -n $DOTFILES_ROOT/tools/statusbar_conf.json.default $DOTFILES_ROOT/tools/statusbar_conf.json

# install tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# set up tools
cd $DOTFILES_ROOT/tools
virtualenv -q -p `which python3` venv
. venv/bin/activate
pip install -q -r requirements.txt

if [ ! -f $(git rev-parse --show-toplevel)/.git/hooks/pre-commit ]; then
    pre-commit install
fi

echo -e "\nChecking exteneral dependencies of notes repo:"
./manage.py check-external-dependencies

echo -e "\nChecking common tools:"
./manage.py check-common-tools

echo -e "\nChecking multimedia:"
./manage.py check-multimedia

echo -e "\nChecking VS Code extensions:"
./manage.py vscode-extensions status
