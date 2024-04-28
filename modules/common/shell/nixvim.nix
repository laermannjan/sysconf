{
  pkgs,
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
        ./nixvim/colorscheme.nix
        ./nixvim/options.nix
        ./nixvim/keymaps.nix
        ./nixvim/treesitter.nix
        ./nixvim/lsp.nix
        ./nixvim/cmp.nix
        ./nixvim/telescope.nix
        # ./nixvim/none-ls.nix
        # ./nixvim/smart-splits.nix
        # ./nixvim/neotest.nix
        # ./nixvim/dap.nix
        # ./nixvim/comment.nix
        # ./nixvim/neotree.nix
        # ./nixvim/todo-comments.nix
        # ./nixvim/lualine.nix
        # ./nixvim/indent-blankline.nix
        # ./nixvim/nvim-autopair.nix
        # ./nixvim/diffview.nix
        # ./nixvim/direnv.nix
        # ./nixvim/git.nix
        # ./nixvim/headlines.nix
        # ./nixvim/hmts.nix
      ];

      programs.nixvim = {
        enable = true;
        colorscheme = lib.mkForce "tokyonight";
      };
    };
  };
}
