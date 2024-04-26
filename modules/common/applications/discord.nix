{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    discord = {
      enable = lib.mkEnableOption {
        description = "Enable discord.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.discord.enable) {
unfreePackages = [ "discord" ];
    home-manager.users.${config.user} = {
    home.packages = with pkgs; [
      discord
    ];
    };
  };
}
