{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.tailscale.enable && pkgs.stdenv.isDarwin) {
    homebrew.casks = [ "tailscale" ];
  };
}
