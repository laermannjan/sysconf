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
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        (python3.withPackages (
          p:
          (with p; [
            python-lsp-server
            pylsp-mypy
            pylsp-rope
            # python-lsp-ruff
            mypy
          ])
        ))
        pyright
        ruff
        pipenv
        pyenv
      ];
    };
  };
}
