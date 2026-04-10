#!/bin/bash
set -euo pipefail

# Find fish binary
if [ -f /opt/homebrew/bin/fish ]; then
    FISH=/opt/homebrew/bin/fish
elif [ -f /home/linuxbrew/.linuxbrew/bin/fish ]; then
    FISH=/home/linuxbrew/.linuxbrew/bin/fish
else
    FISH=$(command -v fish)
fi

# Add fish to allowed shells if not already there
if ! grep -qF "$FISH" /etc/shells; then
    echo "$FISH" | sudo tee -a /etc/shells
fi

# Set fish as default shell
if [ "$SHELL" != "$FISH" ]; then
    sudo chsh -s "$FISH" "$(whoami)"
fi

# Install fisher and update plugins
# NOTE: fisher update must come first so plugins won't be erased from fish_plugins file
$FISH -c '
    curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
    fisher install jorgebucaran/fisher
'
