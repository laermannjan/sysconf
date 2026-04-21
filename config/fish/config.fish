status is-interactive || return

set fish_greeting
set -g fish_color_command blue
fish_add_path --prepend ~/.local/bin

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
    starship init fish | source
end

if command -q cargo
    source ~/.cargo/env.fish
end

if command -q direnv
    direnv hook fish | source
end

if command -q fzf
    # tokyonight-night
    # set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS
    #     --highlight-line --info=inline-right --ansi --layout=reverse --border=none
    #     --color=bg+:#283457,bg:#16161e,border:#27a1b9,fg:#c0caf5,gutter:#16161e,header:#ff9e64,hl+:#2ac3de,hl:#2ac3de,info:#545c7e
    #     --color=marker:#ff007c,pointer:#ff007c,prompt:#2ac3de,query:#c0caf5:regular,scrollbar:#27a1b9,separator:#ff9e64,spinner:#ff007c"
    fzf --fish | source
end

if command -q go
    fish_add_path --prepend ~/go/bin
end

if command -q uv
    uv generate-shell-completion fish | source
    uvx --generate-shell-completion fish | source
end

if command -q zoxide
    zoxide init --cmd cd fish | source
end

if type -q nvm
    nvm use --silent lts || nvm install lts
end

# Shared SSH agent across terminals (Linux only; macOS has a system agent).
# SSH sessions have a forwarded agent, which we don't want to override.
# Keys are loaded on first use via AddKeysToAgent in ~/.ssh/config.
if test (uname) != Darwin && not set -q SSH_CONNECTION
    set -l ssh_env ~/.ssh/environment
    test -f $ssh_env && source $ssh_env &>/dev/null
    ssh-add -l &>/dev/null

    if test $status -eq 2
        ssh-agent -c | grep -v '^echo' >$ssh_env
        chmod 600 $ssh_env
        source $ssh_env &>/dev/null
    end
end
