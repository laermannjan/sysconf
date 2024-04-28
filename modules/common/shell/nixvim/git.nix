{ ... }:
{
  programs.nixvim.plugins = {
    gitblame = {
      enable = true;
    };
    gitsigns = {
      enable = true;
    };
  };
}
