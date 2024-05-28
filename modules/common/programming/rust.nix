{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.rust.enable = lib.mkEnableOption "Rust programming language.";

  config = lib.mkIf config.rust.enable {
    home-manager.users.${config.user} = {
      home.packages =
        let
          ICONV = if pkgs.stdenv.isDarwin then pkgs.darwin.libiconv else pkgs.libiconv;
        in
        with pkgs;
        [
          cargo
          rustc
          clippy
          gcc
          rust-analyzer
          pkg-config
          ICONV
        ];
    };
  };
}
