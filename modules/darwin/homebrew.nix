{...}: {
  homebrew = {
    # Homebrew Package Manager
    enable = true;

    onActivation = {
      autoUpdate = false; # Don't update during rebuild # TODO: does `flake update` do this?
      cleanup = "zap"; # Uninstall all programs not declared
      upgrade = true;
    };

    taps = [
      "homebrew/services"
      "homebrew/cask-versions"
    ];

    # brews = [
    #   "pinentry-mac"
    #   {
    #     name = "tor";
    #     restart_service = true;
    #   }
    #   "torsocks"
    # ];

    casks = [
      "1password" # 1Password will not launch from Nix on macOS
      "karabiner-elements"
      "mullvadvpn"
      "rectangle"
      "signal"
      "tailscale"
      # "thunderbird"
      "docker"
      # "firefox-developer-edition"
    ];
  };
}
