{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.python.enable = lib.mkEnableOption "Python programming language.";

  config = lib.mkIf config.python.enable {
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
        nodePackages.pyright
        ruff
      ];
    };
  };
}
