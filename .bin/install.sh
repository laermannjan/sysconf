#!/usr/bin/env bash

DOTFILES_DIR=$HOME/.dotfiles

function dotfiles {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

function backup {
    mkdir -p "$(dirname "$DOTFILES_DIR/$1")"
    mv "$1" "$DOTFILES_DIR/$1"
}
git clone --bare git@github.com:laermannjan/dotfiles "$DOTFILES_DIR"

mkdir -p "${DOTFILES_DIR}.old"

dotfiles checkout || echo "Backing up pre-existing dotfiles." && dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I@ backup @ && dotfiles checkout

echo " >> Dotfiles installed successfully."
dotfiles config --local status.showUntrackedFiles no
