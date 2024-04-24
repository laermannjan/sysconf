{
  description = "Python pipenv flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    pythonVersion = let
      content = builtins.readFile ./Pipfile;
      version = builtins.head (builtins.match ".*python_version = \"([^\"]+)\".*" content);
      versionWithoutDot = builtins.replaceStrings ["."] [""] version;
      pythonPkgName = "python${versionWithoutDot}";
    in
      pythonPkgName;
  in {
    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        default = pkgs.mkShell {buildInputs = with pkgs; [pipenv pkgs.${pythonVersion}];};
      }
    );
  };
}
