{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.postgres.enable = lib.mkEnableOption "Postgres.";
  config = lib.mkIf (config.postgres.enable) {
    home-manager.users.${config.user}.home.packages = [
      pkgs.pgcli # Postgres client with autocomplete
    ];
  };
}
