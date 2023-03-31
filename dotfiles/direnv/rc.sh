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

# Adapted from https://github.com/direnv/direnv/pull/1019/files
layout_pdm() {
    PYPROJECT_TOML="${PYPROJECT_TOML:-pyproject.toml}"
    if [ ! -f "$PYPROJECT_TOML" ]; then
        log_status "No pyproject.toml found. Executing \`pmd init\` to create a \`$PYPROJECT_TOML\` first."
        pdm init --non-interactive --python "$(python3 --version 2>/dev/null | cut -d' ' -f2 | cut -d. -f1-2)"
    fi

    VIRTUAL_ENV=$(pdm venv list | grep "^\*"  | awk -F" " '{print $3}')

    if [ -z "$VIRTUAL_ENV" ] || [ ! -d "$VIRTUAL_ENV" ]; then
        log_status "No virtual environment exists. Executing \`pdm info\` to create one."
	pdm info
        VIRTUAL_ENV=$(pdm venv list | grep "^\*"  | awk -F" " '{print $3}')
    fi

    PATH_add "$VIRTUAL_ENV/bin"
    export PDM_ACTIVE=1
    export VIRTUAL_ENV
}
