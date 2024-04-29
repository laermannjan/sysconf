from_op() {
    if [[ -t 0 ]] && [[ $# == 0 ]]; then
        log_error "from_op: No input nor arguments given"
        return 1
    fi
    if ! has op; then
        log_error "1Password CLI 'op' not found"
        return 1
    fi

    __from_op < <(
        # Concatenate function args and stdin (if any)
        [[ $# == 0 ]] || printf '%s\n' "${@}"
        [[ -t 0 ]] || cat
    )
}


__from_op() {
    local var val
    local -a op_sessions

    # Store OP_SESSION_* variables, as `op run` removes them
    for var in "${!OP_SESSION_@}"; do
        eval "val=\$$var"
        op_sessions+=("$var=$val")
    done

    direnv_load op run --env-file /dev/stdin --no-masking -- direnv dump

    for var in "${op_sessions[@]}"; do
        export "${var?}"
    done
}
