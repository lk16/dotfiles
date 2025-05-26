# To use this file, add the following to your ~/.profile:
# . /path/to/dotfiles/dotfiles/bash/profile.sh

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export QT_STYLE_OVERRIDE=kvantum

if [ -e /home/luuk/.nix-profile/etc/profile.d/nix.sh ]; then . /home/luuk/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
