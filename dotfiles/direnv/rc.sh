# For details see howto/direnv.md

# Credit to https://rgoswami.me/posts/poetry-direnv/
layout_poetry() {
    if [[ ! -f pyproject.toml ]]; then
        log_error 'No pyproject.toml found.  Use `poetry new` or `poetry init` to create one first.'
        exit 2
    fi

    local VENV=$(dirname $(poetry run which python) 2>/dev/null)
    export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
    export POETRY_ACTIVE=1
    PATH_add "$VENV"

    if ! pip list 2>&1 | grep pdbpp > /dev/null; then
        echo -e "\033[1;31mCould not find pdbpp!\033[0m"
    fi
}
