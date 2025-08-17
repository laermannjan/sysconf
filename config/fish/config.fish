if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
else if test -f /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

 if not contains "$HOME/.local/bin" $PATH
     # Prepending path in case a system-installed binary needs to be overridden
     set -x PATH "$HOME/.local/bin" $PATH
 end

status is-interactive; and begin
    abbr --add -- e nvim
    abbr --add -- elevate 'aws iam add-user-to-group --group-name Elevated --user-name $(aws iam get-user | grep UserName | cut -d'\''"'\'' -f4)'
    abbr --add -- secrets 'aws secretsmanager get-secret-value --secret-id (aws secretsmanager list-secrets | jq -r '\''.[][] | .Name'\'' | fzf) | jq -r .SecretString | tr -d '\''\n'\'' | pbcopy'
    abbr --add -- params 'aws ssm get-parameter --name (aws ssm describe-parameters | jq -r '\''.[][] | .Name'\'' | fzf) | jq -r .Parameter.Value | tr -d '\''\n'\'' | pbcopy'
    abbr --add -- ssh-reset-alcemy 'ssh-keygen -R alhambra-dev.alcemy.tech && ssh-keygen -R alhambra-prod.alcemy.tech'

    function dsn --description "retrieve the DSN for a alcemy prism database"
        set --local env_underscore $(string replace - _ $argv[1])
        set --local env_hyphen $(string replace _ - $argv[1])

        set --local host $(aws ssm get-parameter --name /alcemy/cement/$env_hyphen/db-host/main | jq -r .Parameter.Value | tr -d '\n')
        set --local user "$env_underscore"_user
        set --local pw $(aws secretsmanager get-secret-value --secret-id alcemy/cement/$env_hyphen/prism-db-user-password | jq -r .SecretString | tr -d '\n')
        set --local db alcemy_prism_"$env_underscore"
        echo "postgres://$user:$pw@$host/$db"
    end

    alias eza 'eza --group-directories-first --header --group --git'
    alias la 'eza -a'
    alias ll 'eza -l'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'

    # Disable greeting
    set fish_greeting

    # homebrew completions
    if command -q brew && test -d (brew --prefix)"/share/fish/completions"
        set -p fish_complete_path (brew --prefix)/share/fish/completions
    end

    if command -q brew && test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end

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

    if command -q pipenv
        set -gx PIPENV_VENV_IN_PROJECT 1
    end

    if command -q pyenv
        set -gx PYENV_ROOT $HOME/.pyenv
        fish_add_path --global $PYENV_ROOT/bin
        pyenv init - | source
    end

    if command -q uv
        uv generate-shell-completion fish | source
        uvx --generate-shell-completion fish | source
    end

    if command -q zoxide
        zoxide init --cmd cd fish | source
    end

    # Start ssh-agent if not running, connect to system agent otherwise
    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c)
    end

    # add every ssh key to the agent; prompts for passwords
    for key in ~/.ssh/id_*
        if test -f $key; and not test (string match -r '\.pub$' $key); and not ssh-add -L | string match -q "* $key"
            if test (uname) = "Darwin"
                /usr/bin/ssh-add --apple-use-keychain $key  # ssh-add might be shadowed by openssh installed via homebrew
            else if command -v keychain
                eval (SHELL=fish keychain --eval --quiet $key)
            else
                ssh-add $key
            end
        end
    end

    set -gx XDG_CONFIG_HOME "$HOME/.config"  # needed for lazygit

    # set -gx nvm_default_version "lts"  # this doesn't work, must be set via `set -U ...`


end
