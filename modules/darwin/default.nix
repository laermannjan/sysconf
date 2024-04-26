{...}: {
  imports = [
    # ./alacritty.nix
    ./fish.nix
    ./fonts.nix
    # ./hammerspoon.nix
    ./homebrew.nix
    ./linearmouse
    # ./kitty.nix
    ./networking.nix
    ./nixpkgs.nix
    ./media.nix
    ./system.nix
    # ./tmux.nix
    ./user.nix
    # ./utilities.nix
  ];

  programs.zsh.enable = true;
}
