{
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.${config.user}.programs.starship = {
    enable = true;
    settings = {
      add_newline = false; # Don't print new line at the start of the prompt
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_status"
        "$hostname"
        "$cmd_duration"
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
        show_notifications =
          if pkgs.stdenv.isLinux
          then false
          else true;
        min_time_to_notify = 30000;
        # format = "[$duration]($style) ";
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
      python = {
        format = "[\${version}\\(\${virtualenv}\\)]($style)";
      };
      time = {
        style = "bold yellow";
        time_format = "%M:%M";
        format = "[$time]($style)";
        disabled = false;
      };
    };
  };
}
