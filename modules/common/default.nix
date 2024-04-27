{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./applications
    ./fonts.nix
    ./programming
    ./repositories
    ./shell
  ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      description = "Human readable name of the user";
    };
    userDirs = {
      # Required to prevent infinite recursion when referenced by himalaya
      download = lib.mkOption {
        type = lib.types.str;
        description = "XDG directory for downloads";
        default = if pkgs.stdenv.isDarwin then "$HOME/Downloads" else "$HOME/downloads";
      };
    };
    homePath = lib.mkOption {
      type = lib.types.path;
      description = "Path of user's home directory.";
      default = builtins.toPath (
        if pkgs.stdenv.isDarwin then "/Users/${config.user}" else "/home/${config.user}"
      );
    };
    sysconfPath = lib.mkOption {
      type = lib.types.path;
      description = "Path of sysconf repository.";
      default = config.homePath + "/dev/personal/sysconf";
    };
    sysconfRepo = lib.mkOption {
      type = lib.types.str;
      description = "Link to sysconf repository HTTPS URL.";
    };
    unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of unfree packages to allow.";
      default = [ ];
    };
  };

  config =
    let
      stateVersion = "24.05";
    in
    {
      # Basic common system packages for all devices
      environment.systemPackages = with pkgs; [
        git
        vim
        wget
        curl
      ];

      environment.variables = {
        LANG = "en_US.UTF-8";
      };

      # Use the system-level nixpkgs instead of Home Manager's
      home-manager.useGlobalPkgs = true;

      # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
      # using multiple profiles for one user
      home-manager.useUserPackages = true;

      # home-manager.extraSpecialArgs = {inherit inputs;};

      # Allow specified unfree packages (identified elsewhere)
      # Retrieves package object based on string name
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfreePackages;

      # Pin a state version to prevent warnings
      home-manager.users.${config.user}.home.stateVersion = stateVersion;
      home-manager.users.root.home.stateVersion = stateVersion;
    };
}
