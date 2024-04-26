{ config, lib, ... }:
{
  options = {
    mynixvim = {
      enable = lib.mkEnableOption {
        description = "Enable my nixvim config";
        default = false;
      };
    };
  };

  config = lib.mkIf config.mynixvim.enable {
    home-manager.users.${config.user} = {
      programs.nixvim = {
        enable = true;
      };
    };
  };
}
