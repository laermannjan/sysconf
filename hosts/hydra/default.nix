{
  inputs,
  globals,
  overlays,
  ...
}:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { };
  modules = [
    ../../modules/common
    ../../modules/nixos
    ../../modules/wsl
    globals
    inputs.wsl.nixosModules.wsl
    inputs.home-manager.nixosModules.home-manager
    {
      networking.hostName = "hydra";
      nixpkgs.overlays = overlays;
      identityFile = "/home/${globals.user}/.ssh/id_ed25519";
      wsl = {
        enable = true;
        wslConf.automount.root = "/mnt";
        defaultUser = globals.user;
        startMenuLaunchers = true;
        nativeSystemd = true;
        wslConf.network.generateResolvConf = true; # Turn off if it breaks VPN
        interop.includePath = false; # Including Windows PATH will slow down Neovim command mode
      };

      neovim.enable = true;
      sysconf.enable = true;
      lua.enable = true;
    }
  ];
}