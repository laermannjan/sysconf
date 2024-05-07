{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    aerospace = {
      enable = lib.mkEnableOption {
        description = "Enable tiling window manager aerospace.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.aerospace.enable) {
    homebrew = {
      casks = [ "nikitabobko/tap/aerospace" ];
    };

    home-manager.users.${config.user} = {
      xdg.configFile."aerospace/aerospace.toml".source = ./aerospace/aerospace.toml;
    };
  };
}
