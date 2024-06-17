{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.jetbrains-toolbox.enable) {
    homebrew = {
      casks = [ "jetbrains-toolbox" ];
    };

  };
}
