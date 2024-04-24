{
  config,
  pkgs,
  lib,
  ...
}: {
  # Allows me to make sure I can work on my sysconf locally

  options.sysconf.enable = lib.mkEnableOption "Clone sysconf.";

  config = lib.mkIf config.sysconf.enable {
    home-manager.users.${config.user} = {
      home.activation = {
        # Always clone sysconf repository if it doesn't exist
        cloneSysconf = config.home-manager.users.${config.user}.lib.dag.entryAfter ["writeBoundary"] ''
          if [ ! -d "${config.sysconfPath}" ]; then
              $DRY_RUN_CMD mkdir --parents $VERBOSE_ARG $(dirname "${config.sysconfPath}")
              $DRY_RUN_CMD ${pkgs.git}/bin/git \
                  clone ${config.sysconfRepo} "${config.sysconfPath}"
          fi
        '';
      };

      # Set a variable for sysconf repo, not necessary but convenient
      home.sessionVariables.SYSCONF = config.sysconfPath;
    };
  };
}
