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
