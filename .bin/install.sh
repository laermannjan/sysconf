#!/usr/bin/env bash

echo "Installing Jan's configuration to this system. Buckle up!"
cd "$HOME" || (echo "  ERROR: can't cd into $HOME" && exit 1)

# Install Homebrew
brew_installed=1
echo -n "Installing Homebrew..."
if which brew >& /dev/null;then
    echo "already installed."
else
    brew_installed=0
    echo /bin/bash -c \"\$\(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh\)\"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ret=$?
    if [ $ret -ne 0 ];then
        echo "Failed. Please investigate"
        exit $ret
    fi

    for path in /home/linuxbrew/.linuxbrew $HOME/.linuxbrew /opt/homebrew /usr/local;do
        if [ -f "$path/bin" ];then
            PATH="$path/bin/brew"
        fi
    done
    echo -n "Checking brew doctor..."
    brew doctor
    if [ $? -ne 0 ];then
        exit 1
    fi
    echo "OK"
fi

echo -n "- Installing Brew-file..."
brew install rcmdnk/file/brew-file >& /dev/null  && echo "Ok" || (echo "Failed" && exit 1)

# Save any pre-existing dotfiles that are already in the git repo and install those from the repo in
# their place
export DOTFILES_DIR="${HOME}/.dotfiles"
export BACKUP_DIR="${DOTFILES_DIR}.old"


function dotfiles {
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

function backup {
    echo "Backing up $PWD/$1  =>  $BACKUP_DIR/$1"
    mkdir -p "$(dirname "${BACKUP_DIR}/$1")";
    mv "$1" "${BACKUP_DIR}/$1"
}
export -f backup
git clone --bare git@github.com:laermannjan/dotfiles "$DOTFILES_DIR" && echo "OK" || (echo "Failed" && exit 1)

echo "Backing up pre-existing dotfiles..."
dotfiles status 2>&1 | grep -E "^(\s+)deleted:" | awk '{$1=$1};1' | cut -f 2- -d ' ' | xargs -I{} bash -c 'backup "{}"' && echo "Ok" || echo "Failed"
echo "Checking out dotfiles into \$HOME..."
dotfiles checkout && echo "Ok" || (echo "Failed" && exit 1)
dotfiles config --local status.showUntrackedFiles no

# install applications and packages
echo "Installing from Brewfile (this may take a _long_ while)..."
brew file update || echo "Some Packages could not be installed via Homebrew, will continue setup anyways"

# install fonts
echo -n "Installing fonts..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    fc-cache && echo "Success"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp $HOME/.local/share/fonts/* $HOME/Library/Fonts/ && echo "Success"
else
    echo "Failed [don't know how to install fonts]"
fi

# install doom 
echo "Installing Doom Emacs..."
[ -d "$HOME/.emacs.d" ] && echo "Backing up pre-existing emacs config" && mv --no-target-directory "$HOME/.emacs.d" "$HOME/.emacs.d.old"
git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.emacs.d
$HOME/.emacs.d/bin/doom -y install

echo "System configuration complete!"
