{ pkgs, ... }:
{
  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "default" ''
      ${pkgs.gum}/bin/gum style --margin "1 2" --padding "0 2" --foreground "15" --background "55" "Options"
      ${pkgs.gum}/bin/gum format --type=template -- '  {{ Italic "Run with" }} {{ Color "15" "69" " nix run github:laermannjan/sysconf#" }}{{ Color "15" "62" "someoption" }}{{ Color "15" "69" " " }}.'
      echo ""
      echo ""
      ${pkgs.gum}/bin/gum format --type=template -- \
          '  • {{ Color "15" "57" " readme " }} {{ Italic "Documentation for this repository." }}' \
          '  • {{ Color "15" "57" " rebuild " }} {{ Italic "Switch to this (on github) configuration." }}'
          '  • {{ Color "15" "57" " loadkey " }} {{ Italic "Load an ssh key for this machine using melt." }}' \
      echo ""
      echo ""
    ''
  );
}
