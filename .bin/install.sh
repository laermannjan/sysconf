#!/usr/bin/env bash

export DOTFILES_DIR="${HOME}/.dotfiles"
export BACKUP_DIR="${DOTFILES_DIR}.old"

cd "$HOME" || exit

function dotfiles {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

function backup {
    echo "Backing up $PWD/$1  =>  $BACKUP_DIR/$1"
    mkdir -p "$(dirname "${BACKUP_DIR}/$1")";
    mv "$1" "${BACKUP_DIR}/$1"
}
export -f backup
git clone --bare git@github.com:laermannjan/dotfiles "$DOTFILES_DIR"

dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} bash -c 'backup "{}"'
dotfiles checkout

echo " >> Dotfiles installed successfully."
dotfiles config --local status.showUntrackedFiles no
