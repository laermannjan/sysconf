{...}: {
  imports = [
    ./fish.nix
    ./fonts.nix
    ./homebrew.nix
    ./linearmouse
    ./networking.nix
    ./nixpkgs.nix
    ./meetingbar.nix
    ./media.nix
    ./system.nix
    ./user.nix
  ];

  programs.zsh.enable = true;
}
