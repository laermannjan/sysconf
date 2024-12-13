{
  config,
  lib,
  pkgs,
  ...
}:
{
  home-manager.users.${config.user} = {
    programs.git = {
      includes = [
        {
          path = "~/.config/git/alcemy";
          condition = "gitdir:~/dev/alcemy/";
        }
      ];
    };

    # Personal git config
    # TODO: fix with variables
    xdg.configFile."git/alcemy".text =
      ''
        [user]
            name = "${config.fullName}"
            email = "jan.laermann@alcemy.tech"
            signingkey = ~/.ssh/id_ed25519.alcemy
        [commit]
            gpgsign = true
        [tag]
            gpgsign = true
      ''
      + lib.optionalString (config._1password.enableSshAgent && pkgs.stdenv.isDarwin) ''
        [gpg "ssh"]
            program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      '';
  };
}
