{ pkgs, ... }:
{

  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "loadkey" ''
      printf "\nEnter an optional suffix for your SSH key (press Enter to skip):\n"
      read -r ssh_suffix

      if [ -n "$ssh_suffix" ]; then
        ssh_filename="id_ed25519.${ssh_suffix}"
      else
        ssh_filename="id_ed25519"
      fi

      printf "\nEnter the seed phrase for your SSH key...\n"
      printf "\nThen press ^D when complete.\n\n"
      mkdir -p ~/.ssh/
      ${pkgs.melt}/bin/melt restore ~/.ssh/${ssh_filename}
      printf "\n\nContinuing activation.\n\n"
    ''
  );
}
