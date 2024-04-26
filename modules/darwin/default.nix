{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
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
    unfreePackages = ["raycast"];
    programs.zsh.enable = true;
    home-manager.users.${config.user}.home.packages = with pkgs; [
      monitorcontrol
      raycast
      stats
      iina
      utm
    ];
  };
}
