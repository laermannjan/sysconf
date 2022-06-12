#!/usr/bin/env bash

# Install Homebrew
brew_installed=1
if ! which brew >& /dev/null;then
  brew_installed=0
  echo Homebrew is not installed!
  echo Install now...
  echo /bin/bash -c \"\$\(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh\)\"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ret=$?
  if [ $ret -ne 0 ];then
    echo Failed to install Homebrew... please check your environment
    exit $ret
  fi
  echo

  for path in /home/linuxbrew/.linuxbrew $HOME/.linuxbrew /opt/homebrew /usr/local;do
    if [ -f "$path/bin" ];then
      PATH="$path/bin/brew"
    fi
  done
fi

# Install Brew-file
echo
echo Install Brew-file...
brew install rcmdnk/file/brew-file

# Check if homebrew got problems
if [ $brew_installed -eq 0 ];then
  brew doctor
  if [ $? -ne 0 ];then
    echo Check brew environment!
    exit 1
  fi
fi

# Save any pre-existing dotfiles that are already in the git repo and install those from the repo in
# their place
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

dotfiles checkout 2>&1 | grep -E "^\t" | awk {'print $1'} | xargs -I{} bash -c 'backup "{}"'
dotfiles checkout

echo "Dotfiles installed successfully."
dotfiles config --local status.showUntrackedFiles no

# install applications and packages
echo "Installing from Brewfile (this may take a _long_ while)"
brew file update

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
echo "Installing Doom Emacs"
[ -d "$HOME/.emacs.d" ] && echo "Backing up pre-existing emacs config" && mv "$HOME/.emacs.d" "$HOME/.emacs.d.old"
git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.emacs.d
$HOME/.emacs.d/doom install -y
