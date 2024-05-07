{ ... }:
{
  # This neovim plugin allows (thanks to treesitter) 
  # highlighting languages contained in strings in various places 
  # of a Home Manager configuration nix file.
  programs.nixvim.plugins.hmts.enable = true;
}
