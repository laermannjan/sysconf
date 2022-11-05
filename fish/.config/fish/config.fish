# Install fisher, if it does not exist
if status is-interactive && ! functions --query fisher && test -z "$INTELLIJ_ENVIRONMENT_READER"
    echo hola
    curl -sL https://git.io/fisher | source
    if test -f "$__fisher_path/fish_plugins"
        fisher update
    else
        fisher install jorgebucaran/fisher
    end
end


set fish_greeting
fish_add_path -g ~/bin
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.emacs.d/bin
fish_add_path -g ~/.cargo/bin
# fish_add_path -g ~/.gem/ruby/3.1.0/bin

set -gx EDITOR /Users/jan/.local/bin/lvim