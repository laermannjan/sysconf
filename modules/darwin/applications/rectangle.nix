{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    rectangle = {
      enable = lib.mkEnableOption {
        description = "Enable rectangle.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.rectangle.enable) {
    homebrew = {
      casks = [ "rectangle" ];
    };
  };
}
