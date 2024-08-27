{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    spotify = {
      enable = lib.mkEnableOption {
        description = "Enable Spotify App.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.spotify.enable) {
    unfreePackages = [ "spotify" ];
    home-manager.users.${config.user} = {
      home.packages = [ pkgs.spotify ];
    };
  };
}
