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
        python3 # Standard Python interpreter
        nodePackages.pyright # Python language server
        ruff # formatter & linter
        ruff-lsp # lsp implementation of ruff to use in IDEs
      ];
    };
  };
}
