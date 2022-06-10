if status is-interactive && test -d $HOME/.cofnig/base16-shell
    set -x COLORTERM truecolor
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end
