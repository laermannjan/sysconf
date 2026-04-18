#!/usr/bin/env bash
# Symlink config/ -> ~/.config/
# Sourced by sysconf.sh (helpers/platform already loaded)

config_source="${SYSCONF_DIR}/config"
config_target="${XDG_CONFIG_HOME:-$HOME/.config}"

log "Dotfiles"

mkdir -p "$config_target"

for item in "$config_source"/*; do
    name="$(basename "$item")"
    dest="$config_target/$name"
    # Remove real directories (not symlinks) before linking.
    # ln -sfn: -n prevents following existing symlink targets on both BSD and GNU.
    [[ -d "$dest" && ! -L "$dest" ]] && rm -rf "$dest"
    ln -sfn "$item" "$dest"
    log_ok "$name"
done
