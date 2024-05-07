{ ... }:
{
  programs.nixvim.plugins.nvim-autopairs = {
    enable = true;
    settings = {
      check_ts = true;
      enable_check_bracket_line = false;
    };
  };
}
