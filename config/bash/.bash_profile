source $HOME/.local/bin/env  # created by `uv`

if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"
