#!/usr/bin/env bash

DOTFILES_DIR="${HOME}/.dotfiles"
BACKUP_DIR="${DOTFILES_DIR}.old"

echo "backupdir $BACKUP_DIR"
function dotfiles {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

function backup {
    mkdir -p "$(dirname "${BACKUP_DIR}/$1")";
    mv "$1" "${BACKUP_DIR}/$1"
}
export -f backup
git clone --bare git@github.com:laermannjan/dotfiles "$DOTFILES_DIR"

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
