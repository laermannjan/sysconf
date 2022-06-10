#!/usr/bin/env bash

DOTFILES_DIR=$HOME/.dotfiles

alias dotfiles="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
git clone --bare git@github.com:laermannjan/dotfiles $DOTFILES_DIR

mkdir -p ${DOTFILES_DIR}.old
dotfiles checkout
if [ $? = 0 ]; then
    echo " >> Dotfiles installed successfully.";
else
    echo " >> Backing up pre-existing dotfiles.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I@ mv @ ${DOTFILES_DIR}.old/@
fi;
dotfiles checkout
if [ $? = 0 ]; then
    echo " >> Dotfiles installed successfully."
fi;
dotfiles config --local status.showUntrackedFiles no
