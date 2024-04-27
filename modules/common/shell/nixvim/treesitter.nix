{ ... }:
{
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      folding = true;
      indent = true;
      highlight = true;

      incrementalSelection = {
        enable = true;
        keymaps = {
          initSelection = "<S-space>";
          nodeIncremental = "<S-space>";
          nodeDecremental = "<C-S-space>";
        };
      };
    };

    treesitter-refactor = {
      enable = false; # TODO: would this clash with LSP?
    };

    treesitter-textobjects = {
      enable = true;

      lspInterop = {
        enable = true;
        peekDefinitionCode = {
          "gpf" = "@function.outer";
          "gpc" = "@class.outer";
        };
      };

      select = {
        enable = true;
        lookahead = false; # (don't) automatically jump forward to next target
        keymaps = {
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@call.outer";
          "ic" = "@call.inner";
          "al" = "@loop.outer";
          "il" = "@loop.inner";
        };
      };

      move = {
        enable = true;
        gotoNext = {
          "]f" = "@function.outer";
          "]c" = "@conditional.outer";
        };
        gotoPrevious = {
          "[f" = "@function.outer";
          "[c" = "@conditional.outer";
        };
      };
    };
  };
}
