{pkgs, ...}: let
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
in {
  fonts =
    if pkgs.stdenv.isDarwin
    then {
      fontDir.enable = true;
      fonts = fonts;
    }
    else {
      fontDir.enable = true;
      packages = fonts;
    };
}
