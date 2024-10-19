{
  config,
  pkgs,
  lib,
  ...
}:
{
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
