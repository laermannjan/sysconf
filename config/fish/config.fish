set -gx XDG_CONFIG_HOME ~/.config
set -gx XDG_DATA_HOME ~/.local/share
set -gx XDG_CACHE_HOME ~/.cache
set -gx XDG_STATE_HOME ~/.local/state

fish_add_path --prepend ~/.local/bin # Prepending path in case a system-installed binary needs to be overridden

test -f /home/linuxbrew/.linuxbrew/bin/brew; and set brew_prefix /home/linuxbrew/.linuxbrew
test -f /opt/homebrew/bin/brew; and set brew_prefix /opt/homebrew
if set -q brew_prefix
    set -gx HOMEBREW_NO_ANALYTICS 1
    set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/homebrew/Brewfile
    $brew_prefix/bin/brew shellenv | source
    set -p fish_complete_path $brew_prefix/share/fish/completions
    set -p fish_complete_path $brew_prefix/share/fish/vendor_completions.d
    # Append (not prepend) so user/plugin functions win over brew-provided ones
    set -a fish_function_path $brew_prefix/share/fish/vendor_functions.d
end

# added to python package cairosvg can find a `libcairo.so.2`
set -x DYLD_FALLBACK_LIBRARY_PATH /opt/homebrew/lib

status is-interactive; and begin
    set fish_greeting

    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx PAGER less
    set -gx LESS '-R -F -X --mouse'

    abbr --add -- e nvim
    abbr --add -- delhist 'history | fzf | read -l entry && history delete --exact --case-sensitive -- "$entry"'

    alias ls 'eza --group-directories-first --header --group --git'
    alias la 'ls -a'
    alias ll 'ls -l'
    alias lla 'ls -la'
    alias lt 'ls --tree'

    if command -q starship && test "$TERM" != dumb
        eval (starship init fish)
    end

    if command -q aws
        # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
        complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
    end

    if command -q direnv
        direnv hook fish | source
    end

    if command -q fzf
        # tokyonight-night
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
            --highlight-line --info=inline-right --ansi --layout=reverse --border=none
            --color=bg+:#283457,bg:#16161e,border:#27a1b9,fg:#c0caf5,gutter:#16161e,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e
            --color=marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#27a1b9,separator:#ff9e64,spinner:#ff007c"
        fzf --fish | source
    end

    if command -q uv
        uv generate-shell-completion fish | source
        uvx --generate-shell-completion fish | source
    end

    if command -q zoxide
        zoxide init --cmd cd fish | source
    end

    # Shared SSH agent across terminals (Linux only; macOS has a system agent that handles all of this itself).
    # SSH sessions have a forwarded agent, which we don't want to override.
    # Keys are loaded on first use via AddKeysToAgent in ~/.ssh/config.
    if test (uname) != Darwin; and not set -q SSH_CONNECTION
        set -l ssh_env ~/.ssh/environment
        test -f $ssh_env; and source $ssh_env &>/dev/null
        ssh-add -l &>/dev/null

        if test $status -eq 2 # no agent reachable
            ssh-agent -c | grep -v '^echo' >$ssh_env # strip the `echo Agent pid ...` line
            chmod 600 $ssh_env
            source $ssh_env &>/dev/null
        end
    end

end
