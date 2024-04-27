{
  pkgs,
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
  programs.nixvim = {
    package = pkgs.neovim;
    enable = true;
    viAlias = true;
    vimAlias = true;
    colorschemes.gruvbox = {
      enable = true;
    };
  };
  # };
}
