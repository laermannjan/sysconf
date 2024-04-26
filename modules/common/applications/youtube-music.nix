{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    youtube-music = {
      enable = lib.mkEnableOption {
        description = "Enable YouTube Music App.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.youtube-music.enable) {
    home-manager.users.${config.user} = {
        home.packages = [pkgs.youtube-music];
    };
  };
}
