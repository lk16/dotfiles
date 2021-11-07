# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export DOTFILES_ROOT=$(cd $(dirname $(readlink -e ~/.bashrc))/../..; pwd)

[ -f ~/.notes_root ] && export NOTES_ROOT=$(cat ~/.notes_root)

# If not running interactively, don't do anything else
case $- in
    *i*) ;;
      *) return;;
esac

# load these if they exist
for script in $(find $DOTFILES_ROOT/dotfiles/bash -name '*.sh' | grep -v '/\(rc\|profile\)\.sh$'); do
    echo "loading $script"
    . $script
done

[ -f ~/.server_aliases.sh ] && echo "please move ~/.server_aliases.sh to $DOTFILES_ROOT/dotfiles/bash/servers.sh"

# add to PATH if they exist
[ -d ~/.local/bin ] && PATH=$PATH:~/.local/bin
[ -d /opt/bin ] && PATH=$PATH:/opt/bin

# remove duplicates from PATH
PATH=$(python -c 'import os; from collections import OrderedDict; \
    l=os.environ["PATH"].split(":"); print(":".join(OrderedDict.fromkeys(l)))' )
