# System configuration for my work Macbook
{
  inputs,
  globals,
  overlays,
  ...
}:
inputs.nix-darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = {
    inherit inputs;
  };
  modules = [
    ../../modules/common
    ../../modules/darwin
    ./git.nix
    globals
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = [ inputs.firefox-darwin.overlay ] ++ overlays;
      networking.hostName = "smidr";
      # identityFile = "/Users/${globals.user}/.ssh/id_ed25519";
      # mail.user = globals.user;
      # charm.enable = true;
      # neovim.enable = true;
      # mail.enable = true;
      # mail.aerc.enable = true;
      # mail.himalaya.enable = false;
      _1password.enable = true;
      aerospace.enable = true;
      argo.enable = true;
      applauncher.enable = true;
      brave.enable = true;
      discord.enable = true;
      docker.enable = true;
      firefox.enable = true;
      golang.enable = true;
      lua.enable = true;
      neovim = {
        enable = true;
        config = "custom";
      };
      media.enable = true;
      meetingbar.enable = true;
      monitorcontrol.enable = true;
      mullvad-browser.enable = true;
      mullvad.enable = true;
      nixlang.enable = true;
      notion-calendar.enable = true;
      notion.enable = true;
      rectangle.enable = true;
      obsidian.enable = true;
      postgres.enable = true;
      pycharm.enable = true;
      python.enable = true;
      rust.enable = true;
      slack.enable = true;
      signal.enable = true;
      stats.enable = true;
      sysconf.enable = true;
      tailscale.enable = true;
      terraform.enable = true;
      tor-browser.enable = true;
      utm.enable = true;
      wezterm.enable = true;
      youtube-music.enable = true;
      yt-dlp.enable = true;
    }
  ];
}
