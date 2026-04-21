#!/usr/bin/env bash
# Generate SSH keypair and deploy config
# Sourced by sysconf.sh (helpers/platform already loaded)

log "SSH"

mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Symlink into repo - ~/.ssh perms (700) block other local users from
# the symlink path, and this config is already public on GitHub.
ln -sfn "${SYSCONF_DIR}/config/ssh/config" ~/.ssh/config
log_ok "ssh config"

if [[ -f ~/.ssh/id_ed25519 ]]; then
    log_skip "ssh keypair"
    return 0
fi

ssh-keygen -t ed25519 -C "$USER@$(hostname -s)" -f ~/.ssh/id_ed25519
log_ok "ed25519 keypair"

# Copy public key to clipboard
if is_mac; then
    pbcopy < ~/.ssh/id_ed25519.pub
elif has xclip; then
    xclip -selection clipboard < ~/.ssh/id_ed25519.pub
fi

# Open forge SSH key pages
open_cmd="open"
is_linux && open_cmd="xdg-open"
for url in \
    https://github.com/settings/ssh/new \
    https://gitlab.com/-/user_settings/ssh_keys \
    https://codeberg.org/user/settings/keys; do
    $open_cmd "$url" 2>/dev/null || true
done

echo
read -rp "Public key copied to clipboard. Add it to each forge, then press Enter. "
