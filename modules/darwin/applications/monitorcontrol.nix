{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    monitorcontrol = {
      enable = lib.mkEnableOption {
        description = "Enable monitorcontrol.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.monitorcontrol.enable && pkgs.stdenv.isDarwin) {
    home-manager.users.${config.user}.home.packages = with pkgs; [ monitorcontrol ];
  };
}
