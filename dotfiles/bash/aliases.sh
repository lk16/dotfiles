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
alias gp='git push -u origin $(git branch --show-current)'

alias gggs='~/projects/dotfiles/tools/global_git_status.sh'

alias json="python3 -m json.tool"

alias dps="docker-compose ps"

alias alert="mplayer $DOTFILES_ROOT/tools/airhorn.mp3 -loop 0 > /dev/null 2>&1"

function bright() {
    for output in $(xrandr | grep ' connected ' | cut -d ' ' -f 1); do
        xrandr --output "$output" --brightness $1 2>/dev/null
    done
}

alias dc="docker-compose"

alias find-missing-init="tools find-missing-init $(pwd)"

function playok() {
    (
        cd /home/luuk/projects/othello_tree
        . venv/bin/activate
        # this relies on direnv for env vars
        ./manage.py download-playok-games
    )
}

function othelloquest() {
    (
        cd /home/luuk/projects/othello_tree
        . venv/bin/activate
        # this relies on direnv for env vars
        ./manage.py download-othello-quest-games
    )
}