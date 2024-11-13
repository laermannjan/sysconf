{
  config,
  pkgs,
  lib,
  ...
}:
{
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
        elevate = ''aws iam add-user-to-group --group-name Elevated --user-name $(aws iam get-user | grep UserName | cut -d'"' -f4)'';
        secrets = "aws secretsmanager get-secret-value --secret-id (aws secretsmanager list-secrets | jq -r '.[][] | .Name' | fzf) | jq -r .SecretString | tr -d '\\n' | pbcopy";
        ssh-reset-alcemy = "ssh-keygen -R alhambra-dev.alcemy.tech && ssh-keygen -R alhambra-prod.alcemy.tech";
      };

      # FIXME: This is needed to address bug where the $PATH is re-ordered by
      # the `path_helper` tool, prioritising Apple’s tools over the ones we’ve
      # installed with nix.
      #
      # This gist explains the issue in more detail: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
      # There is also an issue open for nix-darwin: https://github.com/LnL7/nix-darwin/issues/122
      loginShellInit =
        let
          # We should probably use `config.environment.profiles`, as described in
          # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
          # but this takes into account the new XDG paths used when the nix
          # configuration has `use-xdg-base-directories` enabled. See:
          # https://github.com/LnL7/nix-darwin/issues/947 for more information.
          profiles = [
            "/etc/profiles/per-user/$USER" # Home manager packages
            "$HOME/.nix-profile"
            "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
            "/run/current-system/sw"
            "/nix/var/nix/profiles/default"
          ];

          makeBinSearchPath = lib.concatMapStringsSep " " (path: "${path}/bin");
        in
        ''
          # Fix path that was re-ordered by Apple's path_helper
          fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
          set fish_user_paths $fish_user_paths
        '';

      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting

        if command -q aws
            # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
            complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
        end

        # set -x NVIM_APPNAME nvim-astro
        set -gx PIPENV_VENV_IN_PROJECT 1

        # test the program uv is available
        if command -q uv
            # if it is, then run the following commands
            uv generate-shell-completion fish | source
        end


        # type `rds.[identifier]` (followed by enter or space) to expand to alcemy rds tunnel
        function ssh_rds_expand
            set match (string match -g -r '^rds\.([a-z\-]*)(?::(\d*))?$' -- $argv[1])
            set identifier $match[1]
            if test -n "$match[2]"
                set local_port $match[2]
            else
                set local_port 5432
            end

            if test -n "$identifier"
                # If identifier starts with 'dyn-', prefix with 'prism-'
                if string match -q -r '^dyn-.*' -- $identifier
                    set identifier "prism-$identifier"
                end
                echo "ssh -i ~/.ssh/id_ed25519.alcemy -N -L $local_port:$identifier%-db-instance.cxwee7sgwz6s.eu-central-1.rds.amazonaws.com:5432 ec2-user@alhambra-dev.alcemy.tech"
            else
                echo "ssh -i ~/.ssh/id_ed25519.alcemy -N -L $local_port:%-db-instance.cxwee7sgwz6s.eu-central-1.rds.amazonaws.com:5432 ec2-user@alhambra-dev.alcemy.tech"
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
        config_kube_alcemy_dev = "aws eks update-kubeconfig --region eu-central-1 --name dev";
        config_kube_alcemy_prod = "aws eks update-kubeconfig --region eu-central-1 --name prod";
      };

    };
  };
}
