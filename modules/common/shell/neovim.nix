{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    neovim = {
      enable = lib.mkEnableOption {
        description = "Enable my neovim config.";
        default = false;
      };
    };
  };

  config = {
    environment.systemPackages = [ pkgs.neovim ]; # everbody should have this!

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home-manager.users.${config.user} = {
      programs = {
        neovim = {
          enable = true;
        };
      };

      home.file.".config/nvim/" = {
        source = ./neovim;
        recursive = true;
      };

      home.packages = with pkgs; [
        jq
        ripgrep
        fzf
        nodejs # for installing language servers via mason
        go # for installing language servers via mason
        cargo # for installing language servers via mason
        alejandra
        deadnix
        statix
      ];
    };
  };
}
