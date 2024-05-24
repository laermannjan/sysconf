{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    amethyst = {
      enable = lib.mkEnableOption {
        description = "Enable Amethyst.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.amethyst.enable) {
    homebrew = {
      casks = [ "amethyst" ];
    };
  };
}
