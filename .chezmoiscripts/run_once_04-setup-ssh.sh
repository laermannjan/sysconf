#!/bin/bash
set -euo pipefail

mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Only generate key if it doesn't exist
if [ -f ~/.ssh/id_ed25519 ]; then
    echo "SSH key already exists, skipping generation."
    exit 0
fi

# Prompt for passphrase
echo -n "Enter passphrase for new SSH key: "
read -rs passphrase
echo

# Generate keypair
ssh-keygen -t ed25519 \
    -C "$(whoami)@$(hostname -s)" \
    -f ~/.ssh/id_ed25519 \
    -N "$passphrase"

# Copy public key to clipboard
if [ "$(uname)" = "Darwin" ]; then
    pbcopy < ~/.ssh/id_ed25519.pub
    OPEN=open
else
    xclip -selection clipboard < ~/.ssh/id_ed25519.pub
    OPEN=xdg-open
fi

echo "Public key copied to clipboard."

# Open forge SSH key pages
$OPEN "https://github.com/settings/ssh/new"
$OPEN "https://gitlab.com/-/user_settings/ssh_keys"
$OPEN "https://codeberg.org/user/settings/keys"

echo "Add your SSH key to each forge, then press Enter to continue."
read -r
