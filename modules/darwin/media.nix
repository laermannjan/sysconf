{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home-manager.users.${config.user} = {
      programs.mpv.enable = false;
      home.packages = with pkgs; [
        iina # a nice gui for mpv on macOS
      ];
    };
  };
}
