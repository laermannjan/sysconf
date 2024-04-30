{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.users.${config.user}.programs.starship = {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = false; # Don't print new line at the start of the prompt
      fill = " ";
      format = lib.concatStrings [
        "$time"
        "$all"
        "$character"
      ];
      right_format = "$nix_shell";
      character = {
        success_symbol = "[ ](bold bright-green)";
        error_symbol = "[ ](bold red)";
        vicmd_symbol = "[❮](bold green)";
      };
      cmd_duration = {
        min_time = 5000;
        show_notifications = if pkgs.stdenv.isLinux then false else true;
        min_time_to_notify = 30000;
      };
      directory = {
        truncate_to_repo = true;
        truncation_length = 100;
      };
      git_commit = {
        format = "( @ [$hash]($style) )";
        only_detached = false;
      };
      hostname = {
        ssh_only = true;
        format = "on [$hostname](bold red) ";
      };
      nix_shell = {
        format = "[$symbol $name]($style)";
        symbol = "❄️";
      };
      aws.disabled = true;
      time = {
        style = "bold yellow";
        time_format = "%H:%M";
        format = "[$time]($style) ";
        disabled = false;
      };
      custom.env_slug = {
        disabled = false;
        description = "Display ENVIRONMENT_SLUG if set and notify if ";
        when = "[[ $(git ls-remote --get-url) =~ gitlab.com:alcemy ]] && [[ -f $(git rev-parse --show-toplevel)/.env ]]";
        format = "(in [$symbol($output )]($style))";
        style = "bold red";
        command = ''
          SYMBOL=""
          DYN_ENV=$(git branch --show-current | cut -s -d '+' -f 2)

          [[ -z $DYN_ENV ]] && [[ $ENVIRONMENT_SLUG == "testing" ]] && exit

          [[ -z $DYN_ENV ]] && [[ $ENVIRONMENT_SLUG =~ ^dyn_ ]] && SYMBOL="🚧 mismatch "
          [[ -n $DYN_ENV ]] && [[ "dyn_$DYN_ENV" != $ENVIRONMENT_SLUG ]] && SYMBOL="🚧 mismatch "

          [[ -z $ENVIRONMENT_SLUG ]] && ENVIRONMENT_SLUG="<undefined env slug>"

          [[ $ENVIRONMENT_SLUG =~ ^prod ]] && SYMBOL="🛑 $SYMBOL" && ENVIRONMENT_SLUG=$ENVIRONMENT_SLUG

          echo "$SYMBOL$ENVIRONMENT_SLUG"
        '';
        shell = ''["bash", "--noprofile", "--norc"]'';
      };
    };
  };
}
