{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.postgres.enable) {
    homebrew.casks = [ "postgres-unofficial" ];
    home-manager.users.${config.user}.home.sessionPath = [
      "/Applications/Postgres.app/Contents/Versions/latest/bin"
    ];
  };
}
