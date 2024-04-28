{ ... }:
{
  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
    };

    keymaps = [
      # resize
      {
        key = "<A-h>";
        action = "require('smart-splits').resize_left";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-j>";
        action = "require('smart-splits').resize_down";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-k>";
        action = "require('smart-splits').resize_up";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<A-l>";
        action = "require('smart-splits').resize_right";
        lua = true;
        mode = "n";
        options.silent = true;
      }

      # move cursor
      {
        key = "<C-h>";
        action = "require('smart-splits').move_cursor_left";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-j>";
        action = "require('smart-splits').move_cursor_down";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-\\>";
        action = "require('smart-splits').move_cursor_down";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-k>";
        action = "require('smart-splits').move_cursor_up";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-l>";
        action = "require('smart-splits').move_cursor_right";
        lua = true;
        mode = "n";
        options.silent = true;
      }

      # swap buffers
      {
        key = "<C-S-h>";
        action = "require('smart-splits').swap_buf_left";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-S-j>";
        action = "require('smart-splits').swap_buf_down";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-S-k>";
        action = "require('smart-splits').swap_buf_up";
        lua = true;
        mode = "n";
        options.silent = true;
      }
      {
        key = "<C-S-l>";
        action = "require('smart-splits').swap_buf_right";
        lua = true;
        mode = "n";
        options.silent = true;
      }
    ];
  };
}
