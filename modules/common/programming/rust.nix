{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.rust.enable = lib.mkEnableOption "Rust programming language.";

  config = lib.mkIf config.rust.enable {
    home-manager.users.${config.user} =
      let
        libPath = with pkgs; lib.makeLibraryPath [ libiconv ];
      in
      {
        home.packages = with pkgs; [
          cargo
          rustc
          rust-analyzer
          clippy
          gcc
          libiconv
          llvmPackages.bintools
        ];

        home.sessionVariables = {
          LD_LIBRARY_PATH = libPath;
        };
      };
  };
}
