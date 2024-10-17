{ config, pkgs, lib, ... }: {
  users.users.${config.user}.shell = pkgs.fish;
  programs.fish.enable = true; # Needed for LightDM to remember username

  home-manager.users.${config.user} = {
    # Packages used in abbreviations and aliases
    home.packages = with pkgs; [ curl ];

    programs.fish = {
      enable = true;
      shellAliases = {
        # Version of bash which works much better on the terminal
        bash = "${pkgs.bashInteractive}/bin/bash";
      };
      shellAbbrs = {
        e = "nvim";
        elevate = ''
          aws iam add-user-to-group --group-name Elevated --user-name $(aws iam get-user | grep UserName | cut -d'"' -f4)'';
        secrets =
          "aws secretsmanager get-secret-value --secret-id (aws secretsmanager list-secrets | jq -r '.[][] | .Name' | fzf) | jq -r .SecretString | tr -d '\\n' | pbcopy";
        ssh-reset-alcemy =
          "ssh-keygen -R alhambra-dev.alcemy.tech && ssh-keygen -R alhambra-prod.alcemy.tech";
      };
      loginShellInit = let
        # This naive quoting is good enough in this case. There shouldn't be any
        # double quotes in the input string, and it needs to be double quoted in case
        # it contains a space (which is unlikely!)
        dquote = str: ''"'' + str + ''"'';

        makeBinPathList = map (path: path + "/bin");
        # due to fish's weird sourcing order the nix paths won't be in front of the /usr/bin etc. paths, this fixes this
      in ''
        fish_add_path --move --prepend --path ${
          lib.concatMapStringsSep " " dquote
          (makeBinPathList config.environment.profiles)
        }
        set fish_user_paths $fish_user_paths
      '';

      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting

        if command -q aws
            # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
            complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
        end

        # 1password completions
        if command -q op
            op completion fish | source
            source ~/.config/op/plugins.sh
        end

        # allow 1password-cli ssh-agent to see which keys are available
        # `ssh-add -l` will now show all available ssh-keys from 1password
        set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

        # set -x NVIM_APPNAME nvim-astro
        set -gx PIPENV_VENV_IN_PROJECT 1

        if test -f ~/.cache/GITLAB_ACCESS_TOKEN
            set -gx GITLAB_ACCESS_TOKEN (cat ~/.cache/GITLAB_ACCESS_TOKEN)
        else
            set -gx GITLAB_ACCESS_TOKEN (op read "op://private/GitLab Personal Access Token/token")
            echo $GITLAB_ACCESS_TOKEN > ~/.cache/GITLAB_ACCESS_TOKEN
        end

        # test the program uv is available
        if command -q uv
            # if it is, then run the following commands
            uv generate-shell-completion fish | source
        end


        # type `rds.[identifier]` (followed by enter or space) to expand to alcemy rds tunnel
        function ssh_rds_expand
            set match (string match -g -r '^rds\.([a-z\-]*)(?::(\d+))?$' -- $argv[1])
            set identifier $match[1]
            set local_port (or $match[2] 5432)

            if test -n "$identifier"
                # If identifier starts with 'dyn-', prefix with 'prism-'
                if string match -q -r '^dyn-.*' -- $identifier
                    set identifier "prism-$identifier"
                end
                echo "ssh -i ~/.ssh/id_alcemy -N -L $local_port:$identifier%-db-instance.cxwee7sgwz6s.eu-central-1.rds.amazonaws.com:5432 ec2-user@alhambra-dev.alcemy.tech"
            else
                echo "ssh -i ~/.ssh/id_alcemy -N -L $local_port:%-db-instance.cxwee7sgwz6s.eu-central-1.rds.amazonaws.com:5432 ec2-user@alhambra-dev.alcemy.tech"
            end
        end
        abbr --add --position command --regex '^rds\..*$' --function ssh_rds_expand --set-cursor 'rds.*'

      '';

      shellInitLast = ''
        if command -q pyenv
            set -gx PYENV_ROOT $HOME/.pyenv
            fish_add_path --global $PYENV_ROOT/bin
            pyenv init - | source
        end
      '';
      plugins = [
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
      ];

      functions = {
        config_kube_alcemy_dev =
          "aws eks update-kubeconfig --region eu-central-1 --name dev";
        config_kube_alcemy_prod =
          "aws eks update-kubeconfig --region eu-central-1 --name prod";
      };

    };
  };
}
