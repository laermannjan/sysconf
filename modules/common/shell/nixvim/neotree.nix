{ ... }:
{
  programs.nixvim = {
    plugins.neo-tree.enable = true;
    keymaps = [
      {
        key = "<leader>e";
        action = ":Neotree toggle reveal_force_cwd<cr>";
        options.silent = true;
        options.desc = "Toggle NeoTree";
      }
    ];
  };
}
