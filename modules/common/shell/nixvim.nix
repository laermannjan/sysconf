{
  inputs,
  config,
  lib,
  ...
}:
{
  options = {
    nixvim = {
      enable = lib.mkEnableOption {
        description = "Enable my nixvim config";
        default = false;
      };
    };
  };

  config = lib.mkIf config.nixvim.enable {

    home-manager.users.${config.user} = {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
        ./nixvim/cmp.nix
        ./nixvim/colorscheme.nix
        ./nixvim/comment.nix
        ./nixvim/dap.nix
        ./nixvim/diffview.nix
        ./nixvim/direnv.nix
        ./nixvim/git.nix
        ./nixvim/headlines.nix
        ./nixvim/hmts.nix
        ./nixvim/indent-blankline.nix
        ./nixvim/keymaps.nix
        ./nixvim/lazygit.nix
        ./nixvim/lsp.nix
        ./nixvim/lualine.nix
        ./nixvim/neotest.nix
        ./nixvim/neotree.nix
        ./nixvim/none-ls.nix
        ./nixvim/nvim-autopair.nix
        ./nixvim/options.nix
        ./nixvim/smart-splits.nix
        ./nixvim/telescope.nix
        ./nixvim/todo-comments.nix
        ./nixvim/treesitter.nix
        ./nixvim/trouble.nix
        ./nixvim/which-key.nix
      ];

      programs.nixvim = {
        enable = true;
        colorscheme = lib.mkForce "tokyonight";
      };
    };
  };
}
