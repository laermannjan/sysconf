{
  config,
  pkgs,
  lib,
  ...
}: {
  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {
    homebrew = {
      casks = ["linearmouse"];
    };

    home-manager.users.${config.user} = {
      xdg.configFile."linearmouse/linearmouse.json".source = ./linearmouse.json;
    };
  };
}
