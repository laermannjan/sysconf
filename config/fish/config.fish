if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

status is-interactive; and begin
    abbr --add -- e nvim
    abbr --add -- elevate 'aws iam add-user-to-group --group-name Elevated --user-name $(aws iam get-user | grep UserName | cut -d'\''"'\'' -f4)'
    abbr --add -- secrets 'aws secretsmanager get-secret-value --secret-id (aws secretsmanager list-secrets | jq -r '\''.[][] | .Name'\'' | fzf) | jq -r .SecretString | tr -d '\''\n'\'' | pbcopy'
    abbr --add -- ssh-reset-alcemy 'ssh-keygen -R alhambra-dev.alcemy.tech && ssh-keygen -R alhambra-prod.alcemy.tech'

    alias eza 'eza --group-directories-first --header --group --git'
    alias la 'eza -a'
    alias ll 'eza -l'
    alias lla 'eza -la'
    alias ls eza
    alias lt 'eza --tree'

    # Disable greeting
    set fish_greeting

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
        fzf --fish | source
    end

    if command -q keychain
        SHELL=fish eval (keychain --eval --quiet id_ed25519.personal id_ed25519.alcemy)
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
        zoxide init fish | source
    end


end
