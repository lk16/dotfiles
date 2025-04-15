# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If for ANY reason PATH becomes empty, keep the shell usable
if [ -z "${PATH}" ]; then
    PATH="/bin:/usr/bin:/usr/local/bin"
fi

export DOTFILES_ROOT=$(cd $(dirname $(readlink -e ~/.bashrc))/../..; pwd)

export EDITOR=nano

[ -f ~/.notes_root ] && export NOTES_ROOT=$(cat ~/.notes_root)

# If not running interactively, don't do anything else
case $- in
    *i*) ;;
      *) return;;
esac

# load these if they exist
for script in $(find $DOTFILES_ROOT/dotfiles/bash -name '*.sh' | grep -v '/\(rc\|profile\)\.sh$'); do
    . $script
done

# add to PATH if they exist
[ -d ~/.local/bin ] && PATH=$PATH:~/.local/bin
[ -d /opt/bin ] && PATH=$PATH:/opt/bin
[ -d /usr/local/bin ] && PATH=$PATH:/usr/local/bin
[ -d /usr/local/go/bin ] && PATH=$PATH:/usr/local/go/bin

# remove duplicates from PATH
PATH=$(/usr/bin/python -c 'import os; from collections import OrderedDict; \
    l=os.environ["PATH"].split(":"); print(":".join(OrderedDict.fromkeys(l)))' )
