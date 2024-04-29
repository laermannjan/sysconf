{
  description = "A devshell environment for my Python project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      devshell,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) lib;

        # Dynamic Python version extraction
        getPythonVersion =
          content:
          let
            version = builtins.head (builtins.match ".*python_version = \"([^\"]+)\".*" content);
          in
          if version == null then "python3" else "python${builtins.replaceStrings [ "." ] [ "" ] version}";

        pythonVersion = getPythonVersion (builtins.readFile ./Pipfile);
      in
      # Add your Pipenv-managed dependencies here
      {
        devShell = devshell.mkShell {
          imports = [
            devshell.imports.direnv
            devshell.imports.help
          ];
          packages = with pkgs; [
            pythonVersion
            python3Packages.pipenv
          ];
          help = {
            description = "This is the development environment for my project.";
          };
        };
      }
    );
}
