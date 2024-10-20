{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./applications
    ./homebrew.nix
    ./networking.nix
    ./nixpkgs.nix
    ./programming
    ./services
    ./shell
    ./system.nix
    ./user.nix
  ];

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.zsh.enable = true; # make the macos default shell know about nix
  };
}
