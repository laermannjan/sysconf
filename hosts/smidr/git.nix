{ config, ... }:
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
    xdg.configFile."git/alcemy".text = ''
      [user]
          name = "${config.fullName}"
          email = "jan.laermann@alcemy.tech"
          signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINHcjvanj+cRV7JT3yjMasSSNB+DyD/zgouMvFOAJaj8
      [gpg "ssh"]
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
      [commit]
          gpgsign = true
      [tag]
          gpgsign = true
    '';
  };
}
