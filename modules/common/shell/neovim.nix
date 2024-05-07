{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let

  configs = {
    nixvim = {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
        ./neovim/nixvim
      ];
      programs.nixvim = {
        enable = true;
        colorscheme = lib.mkForce "tokyonight";
      };
    };

    astronvim = {

    };

    custom = {
      programs.neovim.enable = true;
      home.file.".config/nvim/" = {
        source = ./neovim/custom;
        recursive = true;
      };

      home.packages = with pkgs; [
        jq
        ripgrep
        fzf
        nodejs
        go
        cargo
        nixfmt
        deadnix
        statix
      ];
    };
  };
in
{
  options = {
    neovim = {
      enable = lib.mkEnableOption {
        description = "Enable my neovim config.";
        default = false;
      };
      config = lib.mkOption {
        description = "Which neovim config to use: nixvim, astronvim, custom";
        default = "astronvim";
      };
    };
  };

  config = lib.mkIf config.neovim.enable {
    environment.systemPackages = [ pkgs.neovim ]; # everybody should have this!

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home-manager.users.${config.user} = configs.${config.neovim.config};
  };
}
