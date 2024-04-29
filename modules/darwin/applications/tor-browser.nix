{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    tor-browser = {
      enable = lib.mkEnableOption {
        description = "Enable tor-browser.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.tor-browser.enable) {
    homebrew = {
      casks = [ "tor-browser" ];
    };
  };
}
