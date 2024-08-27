{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    xsv = {
      enable = lib.mkEnableOption {
        description = "Enable xsv cli - a fast terminal CSV toolkit";
        default = false;
      };
    };
  };
  config = {
    home-manager.users.${config.user} = {
      home.packages = [ pkgs.xsv ];
    };
  };
}
