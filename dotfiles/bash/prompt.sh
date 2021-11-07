#!/bin/bash

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
    branch=$(git rev-parse --git-dir >/dev/null 2>&1 && git rev-parse --abbrev-ref HEAD 2>/dev/null | cut -d '-' -f -3 | tr -d '\n')
    if [ $? -eq 0 ]; then
        echo -n "($branch) "
    fi
}

PS1="\\[${USER_PROMPT_COLOR}\\]\u \W \\[${COLOR_LIGHT_GREEN}\\]\$(parse_git_branch)\\[${USER_PROMPT_COLOR}\\]\$ \\[${USER_COMMAND_COLOR}\\]"
trap '[[ -t 1 ]] && tput sgr0' DEBUG
