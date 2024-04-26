{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    tailscale = {
      enable = lib.mkEnableOption {
        description = "Enable Tailscale.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.tailscale.enable) {
    home-manager.users.${config.user} = {
      home.packages = [ pkgs.tailscale ];
    };
  };
}
