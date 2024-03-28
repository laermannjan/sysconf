# Install fisher, if it does not exist
if status is-interactive && ! functions --query fisher && test -z "$INTELLIJ_ENVIRONMENT_READER"
    curl -sL https://git.io/fisher | source
    if test -f "$__fisher_path/fish_plugins"
        fisher update
    else
        fisher install jorgebucaran/fisher
    end
end

if status is-interactive
    # bind \cf tsm # <C-f> starts tmux-session-manager
end


set fish_greeting

# bin paths
fish_add_path -g ~/.local/bin
fish_add_path -g ~/.emacs.d/bin
fish_add_path -g ~/.cargo/bin

# general env
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
# set -gx NVIM_APPNAME nvim-mini

set -gx PIPENV_VENV_IN_PROJECT 1


# Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

# direnv hook fish | source

# source /Users/jan/.config/op/plugins.sh

hoard shell-config --shell fish | source # hoard completions, adds shortcut to <C-h>
