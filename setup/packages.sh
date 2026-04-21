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
            sudo install -d -m 0755 /etc/apt/keyrings
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

# --- WezTerm (Linux only, macOS via Brewfile) ---

if is_linux && ! has wezterm; then
    log "WezTerm"
    if is_debian; then
        sudo install -d -m 0755 /etc/apt/keyrings
        curl -fsSL https://apt.fury.io/wez/gpg.key \
            | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
        echo "deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *" \
            | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
        quiet sudo apt-get update -y
        sudo apt-get install -y wezterm-nightly
    elif is_redhat; then
        sudo dnf copr enable -y wezfurlong/wezterm-nightly
        sudo dnf install -y wezterm
    fi
    log_ok "wezterm"
elif is_linux; then
    log_skip "wezterm"
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
    UV_PYTHON_PREFERENCE=only-managed \
    brew bundle install --verbose --file "$brewfile" || {
    log_warn "brew bundle failed (arm? some flatpaks are x86_64-only)"
    return 1
}

# --- Toolchain setup (after brew bundle installs uv/rustup) ---

if has uv; then
    log "Python (uv)"
    uv python install
    log_ok "python"

    # Single env so plugins/importers are shared across bean-check, fava, bean-query.
    # Brewfile's uv DSL only supports :with, not --with-executables-from, so it's here.
    # --no-build: fail fast if no wheel for the active Python; --managed-python: use uv's.
    # Python version comes from config/uv/.python-version (symlinked to ~/.config/uv/).
    log "Beancount (+fava)"
    uv tool install beancount \
        --no-build --managed-python \
        --with-executables-from fava \
        --with-executables-from beanquery
    log_ok "beancount"
fi

if has rustup-init; then
    log "Rust (rustup)"
    rustup-init -y --default-toolchain stable --no-modify-path
    log_ok "rust"
fi
