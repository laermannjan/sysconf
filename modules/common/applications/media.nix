{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    media = {
      enable = lib.mkEnableOption {
        description = "Enable media programs.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.media.enable) {
    home-manager.users.${config.user} = {
      # Video player
      programs.mpv = {
        enable = true;
        bindings = {};
        config = {
          image-display-duration = 2; # For cycling through images
          hwdec = "auto-safe"; # Attempt to use GPU decoding for video
        };
        scripts = [
          # Automatically load playlist entries before and after current file
          pkgs.mpvScripts.autoload
        ];
      };
    };
  };
}
