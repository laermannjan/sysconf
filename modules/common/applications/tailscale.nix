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
  config = lib.mkIf (config.tailscale.enable && !pkgs.stdenv.isDarwin) {
    # darwin has a nicer gui-client on homebrew
    home-manager.users.${config.user} = {
      home.packages = [ pkgs.tailscale ];
    };
  };
}
