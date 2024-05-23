{ ... }:
{
  programs.nixvim = {
    plugins.lazygit = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>gz";
        action = ":LazyGit<cr>";
        mode = "n";
        options.silent = true;
        options.desc = "Lazygit";
      }
    ];
  };
}
