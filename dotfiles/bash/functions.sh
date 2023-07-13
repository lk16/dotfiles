function bright() {
    for output in $(xrandr | grep ' connected ' | cut -d ' ' -f 1); do
        xrandr --output "$output" --brightness $1 2>/dev/null
    done
}

function tools(){
    # TODO make this work without changing directory
    (
        cd $DOTFILES_ROOT/tools
        . venv/bin/activate
        ./manage.py "$@"
    )
}

function csvcut(){
    tools csvcut $@
}

function highlight(){
    tools highlight $@
}

function mr(){
    (
        echo $PWD | grep koala-data-api >/dev/null && echo "can't use mr() command for koala-data-api"
        echo $PWD | grep koala-data-api >/dev/null && return 1

        . $DOTFILES_ROOT/tools/venv/bin/activate
        $DOTFILES_ROOT/tools/manage.py create-merge-request "$@"
    )
 }


function playok() {
    (
        cd ~/projects/othello_tree
        . .env
        poetry run ./manage.py download-playok-games
    )
}

function othelloquest() {
    (
        cd ~/projects/othello_tree
        . .env
        poetry run ./manage.py download-othello-quest-games
    )
}

function gp() {
    local branch=$(git branch --show-current)

    if git branch -a | grep "origin/$branch" >/dev/null; then
        git push $@
    else
        git push -u origin $branch $@
    fi
}

function bright() {
    for output in $(xrandr | grep ' connected ' | cut -d ' ' -f 1); do
        xrandr --output "$output" --brightness $1 2>/dev/null
    done
}

function noise() {
    pkill -f 'mplayer.*noise.ogg' || \
    (mplayer $DOTFILES_ROOT/tools/noise.ogg -loop 0 > /dev/null 2>&1 &)
}

function newticket() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: newticket <title> <description>"
        return
    fi
    glab issue create -t "$1" -d "$2" -a luuk.verweij
}
