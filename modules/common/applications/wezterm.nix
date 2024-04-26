{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    wezterm = {
      enable = lib.mkEnableOption {
        description = "Enable WezTerm.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.wezterm.enable) {
    home-manager.users.${config.user} = {
      programs = {
        wezterm = {
          enable = true;
        };
      };
      xdg.configFile."wezterm" = {
        source = ./../../../dotfiles/wezterm;
        recursive = true;
      };
    };
  };
}
