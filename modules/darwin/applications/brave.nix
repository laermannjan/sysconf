{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    brave = {
      enable = lib.mkEnableOption {
        description = "Enable brave.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.brave.enable) {
    homebrew = {
      casks = [ "brave" ];
    };
  };
}
