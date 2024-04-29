{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    mullvad-browser = {
      enable = lib.mkEnableOption {
        description = "Enable mullvad-browser.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.mullvad-browser.enable) {
    homebrew = {
      casks = [ "mullvad-browser" ];
    };
  };
}
