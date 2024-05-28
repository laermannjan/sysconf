{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.rust.enable = lib.mkEnableOption "Rust programming language.";

  config = lib.mkIf config.rust.enable {
    homebrew.brews = [ "libiconv" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        cargo
        rustc
        clippy
        gcc
        rust-analyzer
      ];
    };
  };
}
