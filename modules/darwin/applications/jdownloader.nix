{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    jdownloader = {
      enable = lib.mkEnableOption {
        description = "Enable jdownloader.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.jdownloader.enable && pkgs.stdenv.isDarwin) {
    homebrew = {
      casks = [ "jdownloader" ];
    };
  };
}
