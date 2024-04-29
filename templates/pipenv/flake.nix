{
  description = "Python pipenv flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      getPythonVersion =
        content:
        let
          version = builtins.head (builtins.match ".*python_version = \"([^\"]+)\".*" content);
        in
        if version == null then "python3" else "python${builtins.replaceStrings [ "." ] [ "" ] version}";

      pythonVersion = getPythonVersion (builtins.readFile ./Pipfile);
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.pipenv
              (pkgs.${pythonVersion})
            ];
          };
        }
      );
    };
}
