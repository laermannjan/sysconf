{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    argo = {
      enable = lib.mkEnableOption {
        description = "Enable argo cli";
        default = false;
      };
    };
  };
  config = {
    home-manager.users.${config.user} = {
      home.packages = [ pkgs.argo ];
    };
  };
}
