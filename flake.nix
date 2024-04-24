{
  description = "My system";

  # Other flakes that we want to pull from
  inputs = {
    # Used for system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Used for MacOS system config
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for Windows Subsystem for Linux compatibility
    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used for user packages and dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list for their inputs
    };

    # Use official Firefox binary for macOS
    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    # Global configuration for my system
    globals = rec {
      user = "jan";
      fullName = "Jan Laermann";
      gitName = fullName;
      gitEmail = "git@flabber.mozmail.com";
      sysconfRepo = "https://github.com/laermannjan/sysconf";
    };

    overlays = [];

    # System types to support.
    supportedSystems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    # Contains my full system builds, including home-manager
    # nixos-rebuild switch --flake .#foo
    nixosConfigurations = {
      foo = import ./hosts/arrow {inherit inputs globals overlays;};
    };

    # Contains my full Mac system builds, including home-manager
    # darwin-rebuild switch --flake .#work
    darwinConfigurations = {
      work = import ./hosts/work {inherit inputs globals overlays;};
    };

    # For quickly applying home-manager settings with:
    # home-manager switch --flake .#work
    homeConfigurations = {
      # foo = nixosConfigurations.tempest.config.home-manager.users.${globals.user}.home;
      work = darwinConfigurations.work.config.home-manager.users.${globals.user}.home;
    };

    # Programs that can be run by calling this flake
    apps = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system overlays;};
      in
        import ./apps {inherit pkgs;}
    );

    # Development environments
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system overlays;};
      in {
        # Used to run commands and edit files in this repo
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            stylua
            nixfmt-rfc-style
            shfmt
            shellcheck
          ];
        };
      }
    );

    formatter = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system overlays;};
      in
        pkgs.nixfmt-rfc-style
    );

    # Templates for starting other projects quickly
    templates = rec {
      default = basic;
      basic = {
        path = ./templates/basic;
        description = "Basic program template";
      };
    };
  };
}
