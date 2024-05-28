{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.nodejs.enable = lib.mkEnableOption "NodeJS runtime.";

  config = lib.mkIf config.nodejs.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      nodejs
      # nodePackages."@whoever/whatever"
    ];
  };
}
