{
  pkgs,
}:
{
  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "loadkey" ''
        if [ -n "$suffix" ]; then
        FNAME="id_ed25519.$suffix"
      else
        FNAME="id_ed25519"
      fi
      mkdir -p ~/.ssh/
      echo "Enter the seed phrase for your SSH key:"
      echo "Then press ^D on a new empty line when complete."
      echo "You may run this app prefixed with 'suffix=<suffix>' to append <suffix> to your key file name"
      ${pkgs.melt}/bin/melt restore ~/.ssh/$FNAME

      echo "SSH key loaded as $FNAME."
    ''
  );
}
