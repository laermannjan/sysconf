{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.python.enable {
    homebrew.brews = [
      "gcc"
      "readline"
      "openssl"
      "uv"
    ];
  };
}
