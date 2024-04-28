{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.isDarwin && config._1password.enable) {
    homebrew.casks = [
      "1password" # 1Password will not launch from Nix on macOS
    ];
  };
}
