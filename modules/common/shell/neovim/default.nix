{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    neovim = {
      enable = lib.mkEnableOption {
        description = "Enable my neovim config.";
        default = false;
      };
    };
  };

  config = {
    home-manager.users.${config.user} = {
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
        nodejs # for installing language servers via mason
        alejandra
        deadnix
        statix
      ];
    };
  };
}
