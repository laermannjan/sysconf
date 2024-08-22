{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    borg = {
      enable = lib.mkEnableOption {
        description = "Enable borgbackup and borgmatic cli";
        default = false;
      };
    };
  };
  config = {
    home-manager.users.${config.user} = {
      home.packages = [
        pkgs.borgbackup
        pkgs.borgmatic
      ];
    };
  };
}
