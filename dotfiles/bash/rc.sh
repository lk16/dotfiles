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

# --- Path ---

[ -d $HOME/.local/bin ] && PATH=$PATH:$HOME/.local/bin
[ -d /opt/bin ] && PATH=$PATH:/opt/bin
[ -d /usr/local/bin ] && PATH=$PATH:/usr/local/bin

# --- Rust ---

[ -d $HOME/.cargo/bin ] && PATH=$PATH:$HOME/.cargo/bin

# --- Go ---

[ -d /usr/local/go/bin ] && PATH=$PATH:/usr/local/go/bin

mkdir -p $HOME/.local/bin $HOME/.local/go
export GOBIN=$HOME/.local/bin
export GOPATH=$HOME/.local/go

# --- Python ---

[ -f $HOME/.rye/env ] && source $HOME/.rye/env

# force colored output of pytest
export PYTEST_ADDOPTS="--color=yes"

# force colored output of mypy
export MYPY_FORCE_COLOR=1

# disable unreadable Typer stacktrace
export _TYPER_STANDARD_TRACEBACK=1

# --- Javascript ---

if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# --- Prompt and shell options ---

# don't put duplicate lines in the history.
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
shopt -s histappend

# don't limit history size
HISTSIZE=-1
HISTFILESIZE=-1

# update the values of LINES and COLUMNS after each command
shopt -s checkwinsize

# match all files and zero or more directories and subdirectories
shopt -s globstar

# enables: ctrl + backspace to delete a word
stty werase \^H

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

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

__prompt_command() {
    # has to be first
    local EXIT="$?"

    COLOR_NO_COLOR='\e[0m'
    COLOR_WHITE='\e[1;37m'
    COLOR_BLACK='\e[0;30m'
    COLOR_BLUE='\e[0;34m'
    COLOR_LIGHT_BLUE='\e[1;34m'
    COLOR_GREEN='\e[0;32m'
    COLOR_LIGHT_GREEN='\e[1;32m'
    COLOR_CYAN='\e[0;36m'
    COLOR_LIGHT_CYAN='\e[1;36m'
    COLOR_RED='\e[0;31m'
    COLOR_LIGHT_RED='\e[1;31m'
    COLOR_PURPLE='\e[0;35m'
    COLOR_LIGHT_PURPLE='\e[1;35m'
    COLOR_BROWN='\e[0;33m'
    COLOR_YELLOW='\e[1;33m'
    COLOR_GRAY='\e[0;30m'
    COLOR_LIGHT_GRAY='\e[0;37m'

    # default prompt colors
    USER_PROMPT_COLOR=$COLOR_YELLOW
    USER_COMMAND_COLOR=$COLOR_LIGHT_PURPLE

    # add unwritten history item to ~/.bash_history
    history -a

    # reload history from ~/.bash_history
    history -r

    PS1="\[${USER_PROMPT_COLOR}\]\W \[${COLOR_LIGHT_GREEN}\]\$(parse_git_branch)\[${USER_PROMPT_COLOR}\]"

    # show dollar sign in red if last command failed
    if [ $EXIT != 0 ]; then
        PS1+="\[${COLOR_LIGHT_RED}\]\$\[${USER_COMMAND_COLOR}\]"
    else
        PS1+="\[${COLOR_LIGHT_GREEN}\]\$\[${USER_COMMAND_COLOR}\]"
    fi

    PS1+=" \[${USER_COMMAND_COLOR}\]\[${COLOR_NO_COLOR}\]"
}

# --- Aliases ---

# TODO clean the aliases below

# colorize ls, grep, etc.
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# copy to clipboard
alias c='xclip -in -selection clipboard'

# common typo
alias gig='git'

# show git graph
alias gg="git log --graph --oneline --decorate --all"

# git status shortcut
alias ggs="git status"

# rebase continue shortcut
alias ggrc="git rebase --continue"

# output folder of repo root
alias gitroot='git rev-parse --show-toplevel 2>/dev/null'

# push force with lease
alias ggpf="git push --force-with-lease"

# show current branch
alias gb="git branch --show-current"

# play airhorn sound
alias alert="mplayer $DOTFILES_ROOT/audio/airhorn.mp3 -loop 0 > /dev/null 2>&1"

# docker compose shortcut
alias dc="docker compose"

# kill all docker containers
alias killdocker='docker ps -q | xargs docker stop'

# --- Functions ---

# git push, create upstream branch if it doesn't exist
function gp() {
    local branch=$(git branch --show-current)

    if git branch -a | grep "origin/$branch" >/dev/null; then
        git push $@
    else
        git push -u origin $branch $@
    fi
}

# global git status - show repositories with uncommitted and unpushed changes
# This command finds folders in the home directory that contain a .git folder up to 4 levels deep
function gggs() {
    # get the directory of this script
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # run the global git status command
    cd $SCRIPT_DIR/../../tools
    rye run global-git-status
}

# Toggle white noise on loop, usually bound to hotkey `super` + `space`
function noise() {
    pkill -f 'mplayer.*noise.ogg' || \
    (mplayer $DOTFILES_ROOT/audio/noise.ogg -loop 0 > /dev/null 2>&1 &)
}

# --- SSH config ---

# make sure ssh key forwarding works
[ -f $HOME/.ssh/id_rsa ] && eval $(keychain --eval --quiet id_rsa -q)

# add work key if present
[ -f $HOME/.ssh/id_rsa_work ] && eval $(keychain --eval id_rsa_work -q)

# --- Shell hooks ---

# load direnv if installed
if which direnv > /dev/null; then
    eval "$(direnv hook bash)"
fi
