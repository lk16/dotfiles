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
