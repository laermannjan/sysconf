#!/usr/bin/env bash
# Symlink config/ -> ~/.config/
# Sourced by sysconf.sh (helpers/platform already loaded)

config_source="${SYSCONF_DIR}/config"
config_target="${XDG_CONFIG_HOME:-$HOME/.config}"

log "Linking dotfiles from ${config_source} -> ${config_target}"

mkdir -p "$config_target"

for item in "$config_source"/*; do
    dest="$config_target/$(basename "$item")"
    # Remove real directories (not symlinks) before linking.
    # ln -sfn: -n prevents following existing symlink targets on both BSD and GNU.
    [[ -d "$dest" && ! -L "$dest" ]] && rm -rf "$dest"
    ln -sfn "$item" "$dest"
done
