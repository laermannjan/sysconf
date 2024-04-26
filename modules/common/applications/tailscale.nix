{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    applauncher = {
      enable = lib.mkEnableOption {
        description = "Enable Tailscale.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.tailscale.enable) {
    home.packages = [pkgs.tailscale];
  };
}
