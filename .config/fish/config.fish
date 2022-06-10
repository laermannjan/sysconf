if status is-interactive
    # Commands to run in interactive sessions can go here
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

fish_add_path ~/.cargo/bin
fish_add_path /home/linuxbrew/.linuxbrew/bin

fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.emacs.d/bin

set -x COLORTERM truecolor

alias vim nvim
alias bat batcat

starship init fish | source
zoxide init fish | source
source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish
