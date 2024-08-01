layout_uv() {
    PYPROJECT_TOML="${PYPROJECT_TOML:-pyproject.toml}"
    if [[ ! -f "$PYPROJECT_TOML" ]]; then
        log_status "No pyproject.toml found. Executing \`uv init\` to create a \`$PYPROJECT_TOML\` first."
        uv init
    fi

    VIRTUAL_ENV="$(pwd)/.venv"
    if [[ ! -d $VIRTUAL_ENV ]]; then
        log_status "No virtual environment exists. Executing \`uv sync\` to create one and install dependencies (if any)."
        uv sync
    fi

    PATH_add "$VIRTUAL_ENV/bin"
    export VIRTUAL_ENV
}
