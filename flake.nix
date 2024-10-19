{
  description = "My system";

  # Other flakes that we want to pull from
  inputs = {
    # Used for system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Used for MacOS system config
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # Used for Windows Subsystem for Linux compatibility
    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Used for user packages and dotfiles
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs"; # Use system packages list for their inputs
    };

    # Community packages; used for Firefox extensions
    nur.url = "github:nix-community/nur";

    # Use official Firefox binary for macOS
    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox addon from outside the extension store
    bypass-paywalls-clean = {
      # https://gitlab.com/magnolia1234/bpc-uploads/-/commits/master/?ref_type=HEADS
      url = "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-latest.xpi";
      flake = false;
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "nix-darwin";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pre-commit-hooks,
      ...
    }@inputs:
    let
      # Global configuration for my system
      globals = rec {
        user = "jan";
        fullName = "Jan Laermann";
        gitName = fullName;
        gitEmail = "git@flabber.mozmail.com";
        sysconfRepo = "https://github.com/laermannjan/sysconf";
      };

      overlays = [
        inputs.nur.overlay
        (import ./overlays/bypass-paywalls-clean.nix inputs)
      ];

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#foo
      nixosConfigurations = {
        hydra = import ./hosts/hydra {inherit inputs globals overlays;};
      };

      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#work
      darwinConfigurations = {
        smidr = import ./hosts/smidr { inherit inputs globals overlays; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#smidr
      homeConfigurations = {
        # foo = nixosConfigurations.tempest.config.home-manager.users.${globals.user}.home;
        smidr = darwinConfigurations.smidr.config.home-manager.users.${globals.user}.home;
      };

      # Programs that can be run by calling this flake
      apps = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        import ./apps { inherit pkgs; }
      );

      # Development environments
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        {
          # Used to run commands and edit files in this repo
          default = pkgs.mkShell {
            inherit (self.pre-commit-check.${system}) shellHook;
            buildInputs =
              with pkgs;
              [
                git
                stylua
                nixfmt-rfc-style
                shfmt
                shellcheck
              ]
              ++ self.pre-commit-check.${system}.enabledPackages;
          };
        }
      );

      pre-commit-check = forAllSystems (
        system:
        let
          git-hooks = pre-commit-hooks.lib.${system};
          pkgs = import nixpkgs { inherit system overlays; };
        in
        git-hooks.run {
          src = ./.;
          hooks = {
            deadnix.enable = true;
            nixfmt.enable = true;
            nixfmt.package = pkgs.nixfmt-rfc-style;
          };
        }
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
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
        pipenv = {
          path = ./templates/pipenv;
          description = "Pipenv project template reading python version from Pipfile";
        };
        devshell = {
          path = ./templates/devshell;
          description = "Pipenv project template reading python version from Pipfile";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust project template";
        };
      };
    };
}
