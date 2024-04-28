{ ... }:
{
  programs.nixvim = {
    keymaps = [
      {
        key = "<leader>fg";
        action = ":Telescope git_files show_untracked=true";
        mode = "n";
        options.silent = true;
        options.desc = "find git files";
      }
      {
        key = "<leader>uc";
        action = ":Telescope colorscheme enable_preview=true";
        mode = "n";
        options.silent = true;
        options.desc = "preview colorscheme";
      }
    ];
    plugins = {
      telescope = {
        enable = true;
        extensions = {
          ui-select.enable = true;
          fzf-native.enable = true;
          undo.enable = true;
        };
        keymaps = {
          # "<leader>fg" = {
          #   action = ''git_files { show_untracked = true }'';
          #   options.desc = "find git files";
          # };
          "<leader>ff" = {
            action = "find_files";
            options.desc = "find files";
          };
          "<leader>fw" = {
            action = "grep_string";
            options.desc = "find word/selection";
            mode = [
              "n"
              "v"
            ];
          };
          "<leader>fh" = {
            action = "help_tags";
            options.desc = "find help";
          };
          "<leader>fk" = {
            action = "keymaps";
            options.desc = "find help";
          };
          "<leader>fc" = {
            action = "commands";
            options.desc = "find command";
          };
          "<leader>fm" = {
            action = "man_pages";
            options.desc = "find man page";
          };
          # "<leader>uc" = {
          #   action = "colorscheme enable_preview=true";
          #   options.desc = "preview colorscheme";
          # };
          "<leader>\\" = {
            action = "builtin";
            options.desc = "find telescope command";
          };
          "<leader>/" = {
            action = "live_grep";
            options.desc = "live grep";
          };
          "<leader><leader>" = {
            action = "resume";
            options.desc = "resume last search";
          };
        };
      };
    };
  };
}
