{ ... }:
{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<cr>";
        options.desc = "blame line";
      }
      {
        key = "<leader>gd";
        action = "<cmd>Gitsigns diffthis<cr>";
        options.desc = "git diff against base";
      }
      {
        key = "<leader>ugb";
        action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
        options.desc = "toggle current blame line";
      }
      {
        key = "<leader>ugd";
        action = "<cmd>Gitsigns toggle_deleted<cr>";
        options.desc = "toggle deleted";
      }
    ];
  };
}
