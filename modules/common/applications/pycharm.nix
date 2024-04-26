{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    pycharm = {
      enable = lib.mkEnableOption {
        description = "Enable pycharm.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.pycharm.enable) {
    unfreePackages = [ "pycharm-professional" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ jetbrains.pycharm-professional ];
    };
  };
}
