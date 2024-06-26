{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Requires Homebrew to be installed
    system.activationScripts.preUserActivation.text = ''
      if ! xcode-select --version 2>/dev/null; then
        $DRY_RUN_CMD xcode-select --install
      fi
      if ! /opt/homebrew/bin/brew --version 2>/dev/null; then
        $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
    '';

    # Add homebrew paths to CLI path
    home-manager.users.${config.user}.home.sessionPath = [ "/opt/homebrew/bin/" ];

    homebrew = {
      # Homebrew Package Manager
      enable = true;

      onActivation = {
        autoUpdate = true;
        cleanup = "zap"; # Uninstall all programs not declared, and delete (zap) their associated (config) files
        upgrade = true;
      };

      global = {
        brewfile = true; # Run brew bundle from anywhere
        lockfiles = false; # Don't save lockfile (since running from anywhere)
      };

      brews = [ ];

      taps = [
        "homebrew/services"
        "homebrew/cask-versions"
      ];
    };
  };
}
