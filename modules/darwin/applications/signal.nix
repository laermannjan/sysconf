{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    signal = {
      enable = lib.mkEnableOption {
        description = "Enable signal.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.signal.enable) {
    homebrew = {
      casks = [ "signal" ];
    };
  };
}
