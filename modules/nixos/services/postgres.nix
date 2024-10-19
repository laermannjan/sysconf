{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.postgres.enable {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql;
      settings = { };
      authentication = ''
        local all postgres peer map=root
        local all admin peer map=admin
      '';
      identMap = ''
        root      postgres          postgres
        root      root              postgres
        admin     ${config.user}    admin
      '';
      ensureUsers = [
        {
          name = "admin";
          ensureClauses = {
            createdb = true;
            createrole = true;
            login = true;
          };
        }
      ];
    };
  };
}
