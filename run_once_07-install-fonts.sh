#!/bin/bash
set -euo pipefail

if [ "$(uname)" = "Darwin" ]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

mkdir -p "$FONT_DIR"

# Decrypt and extract font archive
age -d -i ~/.config/chezmoi/key.txt "$(chezmoi source-path)/fonts/fonts.tar.xz.age" | tar xJ -C "$FONT_DIR"

# Update font cache on Linux
if [ "$(uname)" != "Darwin" ]; then
    fc-cache -vf
fi
