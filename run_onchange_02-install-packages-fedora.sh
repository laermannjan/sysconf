#!/bin/bash
set -euo pipefail

# --- Copr repos ---
sudo dnf copr enable -y \
    atim/bandwhich \
    atim/bottom \
    atim/lazydocker \
    atim/lazygit \
    atim/starship \
    errornointernet/packages \
    wezfurlong/wezterm-nightly

# --- 1Password repo ---
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo tee /etc/yum.repos.d/1password.repo > /dev/null <<'REPO'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
enabled=1
REPO

# --- Packages ---
sudo dnf install -y \
    @development-tools \
    @multimedia \
    1password \
    awscli \
    bat \
    coreutils \
    curl \
    direnv \
    doggo \
    du-dust \
    eza \
    fd-find \
    file \
    firefox \
    fish \
    fzf \
    ghostscript \
    git \
    git-delta \
    git-lfs \
    golang \
    httpie \
    imagemagick \
    jq \
    keychain \
    lazydocker \
    lazygit \
    lz4 \
    neovim \
    p7zip \
    parallel \
    podman \
    postgresql \
    procps-ng \
    ripgrep \
    rustup \
    starship \
    tailscale \
    unzip \
    uv \
    wezterm \
    wget \
    yt-dlp \
    zoxide

# --- Flatpaks (skip on WSL2) ---
if ! uname -r | grep -q WSL2; then
    flatpak install -y flathub io.podman_desktop.PodmanDesktop
fi
