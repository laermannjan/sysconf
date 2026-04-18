#!/usr/bin/env bash
# Install packages via system package managers and Homebrew
# Sourced by sysconf.sh (helpers/platform already loaded)

log "Packages"

# Prevent apt from spawning interactive config prompts
export DEBIAN_FRONTEND=noninteractive

# --- 1Password (x86_64 Linux only, macOS via Brewfile) ---

if is_linux && [[ "$(uname -m)" == "x86_64" ]] && ! has 1password; then
    log "1Password"
    if is_debian; then
        if ! find /etc/apt/sources.list.d -name "*1password*" -print -quit 2>/dev/null | grep -q .; then
            sudo install -m 0644 /dev/null /etc/apt/keyrings/1password-archive-keyring.asc
            curl -fsSL https://downloads.1password.com/linux/keys/1password.asc \
                | sudo tee /etc/apt/keyrings/1password-archive-keyring.asc >/dev/null
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/1password-archive-keyring.asc] https://downloads.1password.com/linux/debian/amd64 stable main" \
                | sudo tee /etc/apt/sources.list.d/1password.list >/dev/null
            quiet sudo apt-get update -y
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
    log_ok "1password"
else
    is_linux && log_skip "1password (not x86_64 or already installed)"
fi

# --- Tailscale (skip on WSL2, macOS via Brewfile) ---

if is_linux; then
    if is_wsl2; then
        log_skip "tailscale (WSL2 uses host)"
    elif ! has tailscale; then
        log "Tailscale"
        curl -fsSL https://tailscale.com/install.sh | sh
        log_ok "tailscale"
    else
        log_skip "tailscale"
    fi
fi

# --- Docker engine (Linux only, macOS via Brewfile as Docker Desktop) ---

if is_linux; then
    if [[ ! -f /usr/bin/docker ]]; then
        log "Docker"
        curl -fsSL https://get.docker.com | sudo sh
        log_ok "docker"
    else
        log_skip "docker"
    fi
    sudo usermod -aG docker "$USER"
fi

# --- Zed (Linux only, macOS via Brewfile) ---

if is_linux && [[ ! -f "$HOME/.local/bin/zed" ]]; then
    log "Zed"
    curl -fsSL https://zed.dev/install.sh | sh
    log_ok "zed"
elif is_linux; then
    log_skip "zed"
fi

# --- Homebrew bundle (all platforms) ---

brewfile="${SYSCONF_DIR}/config/homebrew/Brewfile"
quiet brew update
log "Brew bundle"
PATH="/opt/homebrew/bin:/home/linuxbrew/.linuxbrew/bin:$PATH" \
    HOMEBREW_NO_ANALYTICS=1 \
    brew bundle install --verbose --file "$brewfile" || {
    log_warn "brew bundle failed (arm? some flatpaks are x86_64-only)"
    return 1
}

# --- Toolchain setup (after brew bundle installs uv/rustup) ---

if has uv; then
    log "Python (uv)"
    uv python install
    log_ok "python"
fi

if has rustup-init; then
    log "Rust (rustup)"
    rustup-init -y --default-toolchain stable --no-modify-path
    log_ok "rust"
fi
