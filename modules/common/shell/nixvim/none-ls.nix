{ ... }:
{
  programs.nixvim.plugins.none-ls = {
    enable = true;
    sources = {
      code_actions = {
        gomodifytags.enable = true;
        impl.enable = true;
        statix.enable = true;
        gitsigns.enable = true;
      };
      diagnostics = {
        bean_check.enable = true;
        deadnix.enable = true;
        fish.enable = true;
        statix.enable = true;
        todo_comments.enable = true;
        yamllint.enable = true;
        codespell.enable = true;
      };
      formatting = {
        bean_format.enable = true;
        codespell.enable = true;
        fish_indent.enable = true;
        goimports.enable = true;
        gofumpt.enable = true;
        nixfmt.enable = true;
        shfmt.enable = true;
        stylua.enable = true;
      };
    };
  };
}
