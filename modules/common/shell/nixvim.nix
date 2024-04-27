{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
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

    home-manager.users.${config.user} = {
      imports = [ inputs.nixvim.homeManagerModules.nixvim ];
      programs.nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        colorschemes.gruvbox = {
          enable = true;
        };
      };
    };
  };
}
