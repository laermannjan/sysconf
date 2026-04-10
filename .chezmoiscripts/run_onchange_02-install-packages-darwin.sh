#!/bin/bash
set -euo pipefail

eval "$(/opt/homebrew/bin/brew shellenv)"

# --- CLI tools ---
brew install \
    1password-cli \
    awscli \
    bat \
    coreutils \
    curl \
    direnv \
    doggo \
    dust \
    eza \
    fd \
    file \
    fzf \
    ghostscript \
    git \
    git-delta \
    git-lfs \
    go \
    httpie \
    imagemagick \
    jq \
    lazydocker \
    lazygit \
    libpq \
    lz4 \
    neovim \
    p7zip \
    parallel \
    podman \
    ripgrep \
    rustup \
    starship \
    tailscale \
    unzip \
    uv \
    wget \
    yt-dlp \
    zoxide

brew link --force libpq

# --- GUI apps ---
brew install --cask \
    1password \
    arc \
    dockutil \
    firefox@developer-edition \
    jetbrains-toolbox \
    karabiner-elements \
    linearmouse \
    monitorcontrol \
    notion-calendar \
    podman-desktop \
    raycast \
    slack \
    the-unarchiver \
    unar \
    utm \
    wezterm

# --- Fish shell (needed by setup-shell script) ---
brew install fish
