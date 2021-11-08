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
        . $DOTFILES_ROOT/tools/venv/bin/activate
        $DOTFILES_ROOT/tools/manage.py create-merge-request "$@"
    )
 }


function playok() {
    (
        cd /home/luuk/projects/othello_tree
        . venv/bin/activate
        . .env
        ./manage.py download-playok-games
    )
}

function othelloquest() {
    (
        cd /home/luuk/projects/othello_tree
        . venv/bin/activate
        . .env
        ./manage.py download-othello-quest-games
    )
}
