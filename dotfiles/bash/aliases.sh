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

alias alert="mplayer $DOTFILES_ROOT/tools/airhorn.mp3 -loop 0 > /dev/null 2>&1"

alias dc="docker-compose"

alias killdocker='docker ps -q | xargs docker stop'

alias plock='poetry lock --no-update'

alias pir='poetry install --remove-untracked'
