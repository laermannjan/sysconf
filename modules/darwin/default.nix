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
    ./system.nix
    ./user.nix
  ];

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.zsh.enable = true;
    home-manager.users.${config.user}.home.packages = with pkgs; [
      monitorcontrol
      stats # menu bar system inidactors
      utm # VM software that's able to create macOS vms
    ];
  };
}
