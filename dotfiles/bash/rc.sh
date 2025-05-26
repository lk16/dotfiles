# To use this file, add the following to your ~/.bashrc:
# . /path/to/dotfiles/dotfiles/bash/rc.sh

# If for ANY reason PATH becomes empty, keep the shell usable
if [ -z "${PATH}" ]; then
    PATH="/bin:/usr/bin:/usr/local/bin"
fi

# TODO remove this
export DOTFILES_ROOT=$(dirname $(dirname $(dirname $(realpath "${BASH_SOURCE[0]}"))))

# Default editor
export EDITOR=nano

# If not running interactively, don't do anything else
case $- in
    *i*) ;;
      *) return;;
esac

# Load auth scripts if it exists
[ -f ./.auth.sh ] && . ./.auth.sh

# add to PATH if they exist
[ -d $HOME/.local/bin ] && PATH=$PATH:$HOME/.local/bin
[ -d /opt/bin ] && PATH=$PATH:/opt/bin
[ -d /usr/local/bin ] && PATH=$PATH:/usr/local/bin

[ -d $HOME/.cargo/bin ] && PATH=$PATH:$HOME/.cargo/bin

[ -d /usr/local/go/bin ] && PATH=$PATH:/usr/local/go/bin

# load direnv if installed
if which direnv > /dev/null; then
    eval "$(direnv hook bash)"
fi

[ -f $HOME/.rye/env ] && source $HOME/.rye/env

# Set GOBIN to $HOME/.local/bin if it exists, Go will use this to install binaries
[ -d $HOME/.local/bin ] && export GOBIN=$HOME/.local/bin


# remove duplicates from PATH
PATH=$(/usr/bin/python -c '
import os

from collections import OrderedDict

path = os.environ["PATH"].split(":")
print(":".join(OrderedDict.fromkeys(path)))
')

# --- Aliases ---

# TODO clean the aliases below

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cg='grep --color=always'
fi

alias ccat='pygmentize -g'
alias lcat='pygmentize -g -O style=colorful,linenos=1'

# cut and paste
alias c='xclip -in -selection clipboard'
alias p='xclip -out -selection clipboard'

alias ll='ls -l'
alias la="ls -la"
alias l='ls -CF'


alias gig='git'

alias gg="git log --graph --oneline --decorate --all"
alias ggs="git status"
alias gds="git diff --stat"
alias ggsi="git status --ignored"
alias ggc="git checkout"
alias ggr="git rebase"
alias ggrc="git rebase --continue"
alias gitroot='git rev-parse --show-toplevel 2>/dev/null'
alias gv="git rev-parse HEAD | cut -c -8"
alias ggpf="git push --force-with-lease"
alias gb="git branch --show-current"

alias gggs='tools global-git-status'
alias ggtop='git shortlog --summary --email | sort -rn'

# allows using "git conflicts" to list conflicting files
git config --global alias.conflicts "diff --name-only --diff-filter=U"

alias json="python3 -m json.tool"

alias dps="docker-compose ps"

alias alert="mplayer $DOTFILES_ROOT/audio/airhorn.mp3 -loop 0 > /dev/null 2>&1"

alias dc="docker compose"

alias killdocker='docker ps -q | xargs docker stop'

alias plock='poetry lock --no-update'

alias pir='poetry install --sync'

# --- Functions ---

function gp() {
    local branch=$(git branch --show-current)

    if git branch -a | grep "origin/$branch" >/dev/null; then
        git push $@
    else
        git push -u origin $branch $@
    fi
}

function noise() {
    pkill -f 'mplayer.*noise.ogg' || \
    (mplayer $DOTFILES_ROOT/audio/noise.ogg -loop 0 > /dev/null 2>&1 &)
}

# --- Node Version Manager ---

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# --- Shell options ---

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

# enables: ctrl + backspace to delete a word
stty werase \^H

# --- Prompt ---

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

# Add git branch if its present to PS1
parse_git_branch() {
    branch=$(git branch --show-current 2>&1)

    if [ $? -eq 0 ]; then

        if [ ${#branch} -gt 15 ]; then
            branch=$(echo $branch | cut -c -14)…
        fi

        echo -n "($branch) "
    fi
}

PROMPT_COMMAND=__prompt_command

# With help from https://stackoverflow.com/a/16715681

# Fixes from https://superuser.com/a/695350
# Make your \[ and \] strictly matching non-nesting pairs.
# Make sure that all non-printing sequences are within \[ and \] (and that, conversely, that all printing sequences are not).

__prompt_command() {
    # has to be first
    local EXIT="$?"

    # Add unwritten history item to ~/.bash_history
    # Since this runs after every command completes, it should add every command to the history.
    history -a

    # clear history
    history -c

    # reload history from ~/.bash_history
    history -r

    PS1="\[${USER_PROMPT_COLOR}\]\W \[${COLOR_LIGHT_GREEN}\]\$(parse_git_branch)\[${USER_PROMPT_COLOR}\]"

    if [ $EXIT != 0 ]; then
        PS1+="\[${COLOR_LIGHT_RED}\]\$\[${USER_COMMAND_COLOR}\]"        # Add red if exit code non 0
    else
        PS1+="\[${COLOR_LIGHT_GREEN}\]\$\[${USER_COMMAND_COLOR}\]"
    fi

    PS1+=" \[${USER_COMMAND_COLOR}\]\[${COLOR_NO_COLOR}\]"
}

# --- Python tools ---

# force colored output of pytest
export PYTEST_ADDOPTS="--color=yes"

# force colored output of mypy
export MYPY_FORCE_COLOR=1

# disable unreadable Typer stacktrace
export _TYPER_STANDARD_TRACEBACK=1

# --- SSH config ---

# make sure ssh key forwarding works
[ -f $HOME/.ssh/id_rsa ] && eval $(keychain --eval --quiet id_rsa -q)

# add work key if present
[ -f $HOME/.ssh/id_rsa_work ] && eval $(keychain --eval id_rsa_work -q)
