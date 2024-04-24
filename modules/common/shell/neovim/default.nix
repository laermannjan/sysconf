{pkgs, ...}: {
  programs = {
    neovim = {
      enable = true;
    };
  };

  home.file.".config/nvim/" = {
    source = ./nvim-config;
    recursive = true;
  };

  home.packages = with pkgs; [
    jq
    ripgrep
    fzf
    alejandra
    deadnix
    statix
  ];
}
