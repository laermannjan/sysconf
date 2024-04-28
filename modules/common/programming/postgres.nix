{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.postgres.enable = lib.mkEnableOption "Postgres.";
  config = lib.mkIf (config.postgres.enable && pkgs.stdenv.isDarwin) {
    homebrew.casks = [ "postgres-unofficial" ];
    home-manager.users.${config.user}.home.sessionPath = [ "/Applications/Postgres.app/Contents/Versions/latest/bin" ];
  };
}
