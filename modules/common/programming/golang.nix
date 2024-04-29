{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.golang.enable = lib.mkEnableOption "Go programming language.";

  config = lib.mkIf config.golang.enable {
    home-manager.users.${config.user}.programs.go = {
      enable = true;
    };
  };
}
