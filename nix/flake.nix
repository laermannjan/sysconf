{
  description = "My Darwin configuration";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    darwinConfigurations.Jans-MacBook-Pro =
      inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = inputs.nixpkgs { system = "aarch64-darwin"; };
      };

      modules = [
        ({ pkgs, ...}: {
          # darwin preferences and config
          programs.zsh.enable = true;
          programs.fish.enable = true;
          environment.shells = [ pkgs.bash pkgs.zsh pkgs.fish ];
          environment.loginShell = pkgs.fish;
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
         })
      ];
  };
}
