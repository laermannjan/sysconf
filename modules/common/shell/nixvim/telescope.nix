{ ... }:
{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      extensions = {
        ui-select.enable = true;
        fzf-native.enable = true;
        undo.enable = true;
      };
      keymaps = {
        "<leader>fg" = {
          action = "git_files show_untracked=true";
          optionts.desc = "find git files";
        };
        "<leader>ff" = {
          action = "find_files";
          optionts.desc = "find files";
        };
        "<leader>fw" = {
          action = "grep_string";
          optionts = {
            desc = "find word/selection";
            mode = [
              "n"
              "v"
            ];
          };
        };
        "<leader>fh" = {
          action = "help_tags";
          optionts.desc = "find help";
        };
        "<leader>fk" = {
          action = "keymaps";
          optionts.desc = "find help";
        };
        "<leader>fc" = {
          action = "commands";
          optionts.desc = "find command";
        };
        "<leader>fm" = {
          action = "man_pages";
          optionts.desc = "find man page";
        };
        "<leader>uc" = {
          action = "colorscheme enable_preview=true";
          optionts.desc = "preview colorscheme";
        };
        "<leader>\\" = {
          action = "";
          optionts.desc = "find telescope command";
        };
        "<leader>/" = {
          action = "live_grep";
          optionts.desc = "live grep";
        };
        "<leader><leader>" = {
          action = "resume";
          optionts.desc = "resume last search";
        };
      };
    };
  };
}
