#!/usr/bin/env bash
# Install packages via system package managers and Homebrew
# Sourced by sysconf.sh (helpers/platform already loaded)

log "Installing packages"

# Prevent apt from spawning interactive config prompts
export DEBIAN_FRONTEND=noninteractive

# --- System packages (distro-specific names) ---

if is_debian; then
    sudo apt-get update -y || true
    sudo apt-get install -y build-essential man-db procps
elif is_redhat; then
    sudo dnf install -y @"Development Tools" @Multimedia postgresql procps-ng
fi

# --- 1Password (x86_64 Linux only, macOS via Brewfile) ---

if is_linux && [[ "$(uname -m)" == "x86_64" ]] && ! has 1password; then
    log "Installing 1Password"
    if is_debian; then
        if ! find /etc/apt/sources.list.d -name "*1password*" -print -quit 2>/dev/null | grep -q .; then
            sudo install -m 0644 /dev/null /etc/apt/keyrings/1password-archive-keyring.asc
            curl -fsSL https://downloads.1password.com/linux/keys/1password.asc \
                | sudo tee /etc/apt/keyrings/1password-archive-keyring.asc >/dev/null
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/1password-archive-keyring.asc] https://downloads.1password.com/linux/debian/amd64 stable main" \
                | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
            sudo apt-get update -y
        fi
        sudo apt-get install -y 1password 1password-cli
    elif is_redhat; then
        sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
        sudo tee /etc/yum.repos.d/1password.repo >/dev/null <<'REPO'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
enabled=1
REPO
        sudo dnf install -y 1password 1password-cli
    fi
    log_ok "1Password"
else
    is_linux && log_skip "1Password (not x86_64 or already installed)"
fi

# --- Tailscale (skip on WSL2, macOS via Brewfile) ---

if is_linux; then
    if is_wsl2; then
        log_skip "Tailscale (WSL2 uses host's Tailscale)"
    elif ! has tailscale; then
        log "Installing Tailscale"
        curl -fsSL https://tailscale.com/install.sh | sh
        log_ok "Tailscale"
    else
        log_skip "Tailscale (already installed)"
    fi
fi

# --- Docker engine (Linux only, macOS via Brewfile as Docker Desktop) ---

if is_linux; then
    if [[ ! -f /usr/bin/docker ]]; then
        log "Installing Docker"
        curl -fsSL https://get.docker.com | sudo sh
        log_ok "Docker"
    else
        log_skip "Docker (already installed)"
    fi
    sudo usermod -aG docker "$USER" 2>/dev/null || true
fi

# --- Flatpak (skip on WSL2, macOS uses casks) ---

if is_linux; then
    if is_wsl2; then
        log_skip "Flatpak (no GUI on WSL2)"
    else
        log "Setting up Flatpak"
        if is_debian; then
            sudo apt-get install -y flatpak
        elif is_redhat; then
            sudo dnf install -y flatpak
        fi
        flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        log_ok "Flatpak + Flathub"
    fi
fi

# --- Zed (Linux only, macOS via Brewfile) ---

if is_linux && [[ ! -f "$HOME/.local/bin/zed" ]]; then
    log "Installing Zed"
    curl -fsSL https://zed.dev/install.sh | sh
    log_ok "Zed"
elif is_linux; then
    log_skip "Zed (already installed)"
fi

# --- Homebrew bundle (all platforms) ---

brewfile="${XDG_CONFIG_HOME:-$HOME/.config}/homebrew/Brewfile"
log "Running brew bundle"
PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:$PATH" \
    HOMEBREW_NO_ANALYTICS=1 \
    brew bundle install --file "$brewfile" || {
    log_warn "brew bundle had failures (commonly arch-unavailable flatpaks)"
}
