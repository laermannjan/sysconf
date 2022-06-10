#!/usr/bin/env bash

DOTFILES_DIR=$HOME/.dotfiles

function dotfiles {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

backup() {
    mkdir -p "$(dirname "$DOTFILES_DIR/$1")";
    mv "$1" "$DOTFILES_DIR/$1"
}
export -f backup
git clone --bare git@github.com:laermannjan/dotfiles "$DOTFILES_DIR"

mkdir -p "${DOTFILES_DIR}.old"

dotfiles checkout 
if [ $? = 0 ]; then 
    echo " >> Dotfiles installed successfully.";
    else 
    echo "Backing up pre-existing dotfiles.";
        dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} bash -c 'backup "{}"'
fi;
dotfiles checkout

echo " >> Dotfiles installed successfully."
dotfiles config --local status.showUntrackedFiles no
