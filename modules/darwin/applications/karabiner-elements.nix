{
  config,
  lib,
  ...
}:
{
  options.karabiner-elements.enable = lib.mkEnableOption "karabiner-elements.";
  config = lib.mkIf (config.karabiner-elements.enable) {
    homebrew.casks = [ "karabiner-elements" ];
    home-manager.users.${config.user} = {
      xdg.configFile."karabiner/karabiner.json".source = ./karabiner/karabiner.json;
    };
  };
}
