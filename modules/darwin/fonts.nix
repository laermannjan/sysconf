{
  pkgs,
  config,
  lib,
  ...
}: {
  home-manager.users.${config.user} = lib.mkIf pkgs.stdenv.isDarwin {
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "Monaspace"
            "Meslo"
            "SourceCodePro"
            "JetBrainsMono"
            "Inconsolata"
            "Hack"
            "FiraCode"
            "ComicShannsMono" # try to get ComicCodeMono instead
          ];
        })
      ];
    };
  };
}
