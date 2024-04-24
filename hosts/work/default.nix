# System configuration for my work Macbook
{
  inputs,
  globals,
  overlays,
  ...
}:
inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = {};
  modules = [
    ../../modules/common
    ../../modules/darwin
    globals
    inputs.home-manager.darwinModules.home-manager
    {
      nixpkgs.overlays = [inputs.firefox-darwin.overlay] ++ overlays;
      networking.hostName = "smidr";
      # identityFile = "/Users/${globals.user}/.ssh/id_ed25519";
      # mail.user = globals.user;
      # atuin.enable = true;
      # charm.enable = true;
      # neovim.enable = true;
      # mail.enable = true;
      # mail.aerc.enable = true;
      # mail.himalaya.enable = false;
      wezterm.enable = true;
      # discord.enable = true;
      # firefox.enable = true;
      sysconf.enable = true;
      neovim.enable = true;
      # nixlang.enable = true;
      # terraform.enable = true;
      # python.enable = true;
      # rust.enable = true;
      # lua.enable = true;
      # obsidian.enable = true;
      # kubernetes.enable = true;
      _1password.enable = true;
      # slack.enable = true;
    }
  ];
}
