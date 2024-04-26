{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./1password.nix
    ./applauncher.nix
    ./docker.nix
    ./fish.nix
    ./homebrew.nix
    ./linearmouse
    ./networking.nix
    ./nixpkgs.nix
    ./meetingbar.nix
    ./media.nix
    ./system.nix
    ./user.nix
  ];

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {
    programs.zsh.enable = true;
    home-manager.users.${config.user}.home.packages = with pkgs; [
      monitorcontrol
      stats  # menu bar system inidactors
      utm  # VM software that's able to create macOS vms
    ];
  };
}
