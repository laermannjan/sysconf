{ config, ... }:
{
  # Enables quickly entering Nix shells when changing directories
  home-manager.users.${config.user} = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = false;
      config = {
        global = {
          warn_timeout = 0;
          hide_env_diff = true;
        };
        whitelist = {
          prefix = [ config.sysconfPath ];
        };
      };
    };
    xdg.configFile."direnv/lib" = {
      source = ./direnv;
      recursive = true;
    };
  };

  # Prevent garbage collection
  nix.extraOptions = ''
    keep-outputs = false
    keep-derivations = false
  '';
}
