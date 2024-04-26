{ config, lib, ... }:
{
  options = {
    nixvim = {
      enable = lib.mkEnableOption {
        description = "Enable my nixvim config";
        default = false;
      };
    };
  };

  config = lib.mkIf config.nixvim.enable {
    # programs.neovim.enable = true;
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      colorschemes.tokyonight = {
        enable = true;
        style = "night";
      };
    };
  };
}
