{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    battle-net = {
      enable = lib.mkEnableOption {
        description = "Enable battle-net.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.battle-net.enable) {
    homebrew = {
      casks = [ "battle-net" ];
    };
  };
}
