{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.python.enable = lib.mkEnableOption "Python programming language.";

  config = lib.mkIf config.python.enable {
    homebrew.brews = [
      "gcc"
      "readline"
      "openssl"
      "pyenv"
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        pyright
        ruff
        pipenv
      ];
    };
  };
}
