{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.${config.user}.shell = pkgs.fish;
  programs.fish.enable = true; # Needed for LightDM to remember username

  home-manager.users.${config.user} = {
    # Packages used in abbreviations and aliases
    home.packages = with pkgs; [curl eza];

    programs.fish = {
      enable = true;
      shellAliases = {
        # Version of bash which works much better on the terminal
        bash = "${pkgs.bashInteractive}/bin/bash";
      };
      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting

         # Enable AWS CLI autocompletion: github.com/aws/aws-cli/issues/1079
        complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

        # 1password completions
        op completion fish | source
        source ~/.config/op/plugins.sh

        # allow 1password-cli ssh-agent to see which keys are available
        # `ssh-add -l` will now show all available ssh-keys from 1password
        set -x SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

        # set -x NVIM_APPNAME nvim-astro
        set -x PIPENV_VENV_IN_PROJECT 1

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
    };
  };
}
