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
          email = "git@flabber.mozmail.com"
    '';
  };
}
