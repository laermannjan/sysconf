{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    applauncher = {
      enable = lib.mkEnableOption {
        description = "Enable Applauncher.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.applauncher.enable) {
    homebrew.casks = [
      "alfred"
      "raycast"
    ];
  };
}
