#!/usr/bin/env bash
# Install fish and set as default shell
# Sourced by sysconf.sh (helpers/platform already loaded)

log "Setting up shell"

if is_mac; then
    brew install fish
elif is_debian; then
    sudo apt-get install -y fish
elif is_redhat; then
    sudo dnf install -y fish
fi

# On macOS, use Homebrew's fish. On Linux, use distro fish (not linuxbrew's)
# so the login shell doesn't depend on linuxbrew.
if is_mac; then
    fish_bin="$(PATH="/opt/homebrew/bin:/usr/local/bin:$PATH" command -v fish)"
else
    fish_bin="$(PATH="/usr/bin:/usr/local/bin:$PATH" command -v fish)"
fi

if grep -qxF "$fish_bin" /etc/shells; then
    log_skip "fish already in /etc/shells"
else
    echo "$fish_bin" | sudo tee -a /etc/shells >/dev/null
    log_ok "Added fish to /etc/shells"
fi

# getent doesn't exist on macOS, use dscl instead
if is_mac; then
    current_shell="$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')"
else
    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
fi

if [[ "$current_shell" == "$fish_bin" ]]; then
    log_skip "fish already default shell"
else
    sudo chsh -s "$fish_bin" "$USER"
    log_ok "Set fish as default shell"
fi
