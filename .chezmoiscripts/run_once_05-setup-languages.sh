#!/bin/bash
set -euo pipefail

# Ensure brew is on PATH
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Rust
if [ ! -f "$HOME/.cargo/bin/cargo" ]; then
    rustup-init -y
fi

# Python
uv python install

# pip packages
uv pip install --system pynvim beancount

# Node via fish + nvm.fish
# NOTE: fisher update must come first so plugins won't be erased from fish_plugins file
fish -c '
    fisher update
    fisher install jorgebucaran/nvm.fish
    nvm install lts
'
