# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

export DOTFILES_ROOT=$(cd $(dirname $(readlink -e ~/.bashrc))/..; pwd)

[ -f ~/.notes_root ] && export NOTES_ROOT=$(cat ~/.notes_root)

# If not running interactively, don't do anything else
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

export COLOR_NO_COLOR='\e[0m'
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[0;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'


# default prompt colors
USER_PROMPT_COLOR=$COLOR_YELLOW
USER_COMMAND_COLOR=$COLOR_LIGHT_PURPLE

# prompt colors for root
if [ $UID -eq "0" ]; then
    USER_PROMPT_COLOR=$COLOR_LIGHT_RED
    USER_COMMAND_COLOR=$COLOR_LIGHT_RED
fi

# Add git branch if its present to PS1
parse_git_branch() {
    branch=$(git rev-parse --git-dir >/dev/null 2>&1 && git rev-parse --abbrev-ref HEAD 2>/dev/null | cut -d '-' -f -3 | tr -d '\n')
    if [ $? -eq 0 ]; then
        echo -n "($branch) "
    fi
}

PS1="\\[${USER_PROMPT_COLOR}\\]\u \W \\[${COLOR_LIGHT_GREEN}\\]\$(parse_git_branch)\\[${USER_PROMPT_COLOR}\\]\$ \\[${USER_COMMAND_COLOR}\\]"
trap '[[ -t 1 ]] && tput sgr0' DEBUG

# load these if they exist
[ -f $DOTFILES_ROOT/dotfiles/.bash_aliases.sh ] && source $DOTFILES_ROOT/dotfiles/.bash_aliases.sh
[ -f $DOTFILES_ROOT/dotfiles/.bash_functions.sh ] && source $DOTFILES_ROOT/dotfiles/.bash_functions.sh
[ -f ~/.server_aliases.sh ] && source ~/.server_aliases.sh

# make sure ssh key forwarding works
[ -f ~/.ssh/id_rsa ] && ssh-add ~/.ssh/id_rsa 2>&1 | grep -v 'Identity added:'

# add work key if present
[ -f ~/.ssh/id_rsa_work ] && eval $(keychain --eval id_rsa_work -q)

# add to PATH if they exist
[ -d ~/.local/bin ] && PATH=$PATH:~/.local/bin
[ -d /opt/bin ] && PATH=$PATH:/opt/bin
[ -d /usr/local/go/bin ] && PATH=$PATH:/usr/local/go/bin
[ -d ~/.pyenv/bin ] && PATH=$PATH:~/.pyenv/bin
[ -d ~/.poetry/bin ] && PATH=$PATH:~/.poetry/bin

# enables: ctrl + backspace to delete a word
stty werase \^H

if which pyenv > /dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi

# load rust/cargo env if it exists
[ -f ~/.cargo/env ] && . ~/.cargo/env

# load direnv
if which direnv > /dev/null; then
    eval "$(direnv hook bash)"
fi
