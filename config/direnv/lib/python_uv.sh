layout_uv() {
    VIRTUAL_ENV="$(pwd)/.venv"
    if [[ ! -d $VIRTUAL_ENV ]]; then
        log_status "No virtual environment exists. Executing \`uv sync\` to create one and install dependencies (if any)."
        uv sync
    fi

    PATH_add "$VIRTUAL_ENV/bin"
    export UV_ACTIVE=1  # or VENV_ACTIVE=1
    export VIRTUAL_ENV
}
