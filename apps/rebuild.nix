{ pkgs, ... }:
{
  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "rebuild" ''
      echo ${pkgs.system}
      SYSTEM=${if pkgs.stdenv.isDarwin then "darwin" else "linux"}
      if [ "$SYSTEM" == "darwin" ]; then
          sudo darwin-rebuild switch --flake ${builtins.toString ../.}
      else
          sudo nixos-rebuild switch --flake ${builtins.toString ../.}
      fi
    ''
  );
}
