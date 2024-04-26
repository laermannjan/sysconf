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
    # programs.neovim.enable = true;
    programs.nixvim = {
      enable = true;
    };
  };
}
