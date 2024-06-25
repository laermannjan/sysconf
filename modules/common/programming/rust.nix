{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.rust.enable = lib.mkEnableOption "Rust programming language.";

  config = lib.mkIf config.rust.enable {
    homebrew.brews = [
      "gcc"
      "readline"
      "openssl"
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ rustup ];
    };
  };
}
