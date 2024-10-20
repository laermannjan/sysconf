{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./applications
    ./shell
    ./homebrew.nix
    ./networking.nix
    ./nixpkgs.nix
    ./services.nix
    ./system.nix
    ./user.nix
  ];

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.zsh.enable = true; # make the macos default shell know about nix
  };
}
