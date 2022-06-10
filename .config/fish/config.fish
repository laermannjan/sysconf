if status is-interactive
    # Commands to run in interactive sessions can go here
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
    set -x COLORTERM truecolor
end

fish_add_path -g ~/bin
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.emacs.d/bin
fish_add_path -g ~/.cargo/bin

switch (uname)
    case Linux
        eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
        if command -s asdf
            source /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.fish
        end
    case Darwin
        eval (/opt/homebrew/bin/brew shellenv)
end
if test -f (brew --prefix)/etc/brew-wrap.fish
  source (brew --prefix)/etc/brew-wrap.fish
end

if command -s starship
    starship init fish | source
end
if command -s zoxide > /dev/null
    zoxide init fish | source
end
