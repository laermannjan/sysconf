{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    neovim = {
      enable = lib.mkEnableOption {
        description = "Enable my neovim config.";
        default = false;
      };
      config = lib.mkOption {
        description = "Which neovim config to use: nixvim, astronvim, custom";
        type = lib.types.either (lib.types.enum [
          "nixvim"
          "astronvim"
          "custom"
        ]) lib.types.str;
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

    home-manager.users.${config.user} =
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
            programs.neovim = {
              enable = true;
              withPython3 = true;
              withNodeJs = true;
            };
            xdg.configFile."nvim" = {
              source = ./neovim/astronvim;
              recursive = true;
            };
            home.packages = with pkgs; [
              ripgrep
              fzf
              jq
              bat
              gdu
              lazygit
            ];
          };

          custom = {
            programs.neovim.enable = true;
            xdg.configFile."nvim" = {
              source = ./neovim/custom;
              recursive = true;
            };

            home.packages = with pkgs; [
              # jq
              ripgrep
              fzf
              nixfmt-rfc-style
              deadnix
              statix
              go
              nodejs
              gcc
            ];
          };
        };
      in
      configs.${config.neovim.config};
  };
}
