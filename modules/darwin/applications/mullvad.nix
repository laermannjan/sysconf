{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    mullvad = {
      enable = lib.mkEnableOption {
        description = "Enable mullvad.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.mullvad.enable) {
    homebrew = {
      casks = [ "mullvadvpn" ];
    };
  };
}
