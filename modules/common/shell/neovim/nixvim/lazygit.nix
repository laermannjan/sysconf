{ ... }:
{
  programs.nixivm = {
    plugins.lazygit = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>gz";
        actions = ":LazyGit<cr>";
        mode = "n";
        options.silent = true;
        options.desc = "Lazygit";
      }
    ];
  };
}
