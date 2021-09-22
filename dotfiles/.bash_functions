function bright() {
    for output in $(xrandr | grep ' connected ' | cut -d ' ' -f 1); do
        xrandr --output "$output" --brightness $1 2>/dev/null
    done
}

function tools(){
    (
        cd $NOTES_ROOT_FOLDER/tools
        . venv/bin/activate
        ./manage.py "$@"
    )
}

function csvcut(){ tools csvcut $@; }
function confirm(){ tools confirm $@; }
function highlight(){ tools highlight $@; }
function mrs(){ tools mrs $@; }
function mr(){ tools mr $@; }
