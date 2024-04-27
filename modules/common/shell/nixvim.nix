{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  # options = {
  #   nixvim = {
  #     enable = lib.mkEnableOption {
  #       description = "Enable my nixvim config";
  #       default = false;
  #     };
  #   };
  # };
  #
  # config = lib.mkIf config.nixvim.enable {
  #
  #   environment.systemPackages = [ pkgs.neovim ];
  home-manager.users.${config.user} = {
    imports = [ inputs.nixvim.homeManagerModules.nixvim ];
    programs.nixvim = {
      # package = pkgs.neovim;
      enable = true;
      viAlias = true;
      vimAlias = true;
      colorschemes.gruvbox = {
        enable = true;
      };
    };
  };
}
