{ ... }:
{
  programs.nixvim = {
    colorschemes = {
      tokyonight = {
        enable = true;
        settings = {
          style = "night";
        };
      };
      rose-pine = {
        enable = true;
      };
    };
  };
}
