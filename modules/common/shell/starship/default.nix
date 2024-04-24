{
  pkgs,
  config,
  lib,
  ...
}: {
  home-manager.users.${config.user} = {
    programs = {
      starship = {
        enable = true;
      };
    };
    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
