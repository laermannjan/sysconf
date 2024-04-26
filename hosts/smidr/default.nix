# System configuration for my work Macbook
{
  inputs,
  globals,
  overlays,
  ...
}:
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { };
  modules = [
    ../../modules/common
    ../../modules/darwin
    globals
    inputs.home-manager.darwinModules.home-manager
    inputs.nixvim.homeManagerModules.nixvim
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
      argo.enable = true;
      discord.enable = true;
      docker.enable = true;
      firefox.enable = true;
      golang.enable = true;
      lua.enable = true;
      media.enable = true;
      # neovim.enable = true;
      nixlang.enable = true;
      mynixvim.enable = true;
      obsidian.enable = true;
      pycharm.enable = true;
      python.enable = true;
      rust.enable = true;
      slack.enable = true;
      sysconf.enable = true;
      tailscale.enable = true;
      terraform.enable = true;
      wezterm.enable = true;
      yt-dlp.enable = true;
    }
  ];
}
