{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = {
    home-manager.users.${config.user} = lib.mkMerge [
      # Base SSH configuration
      {
        programs.ssh = {
          enable = true;
          forwardAgent = true;
          extraConfig =
            ''
              IgnoreUnknown AddKeysToAgent,UseKeychain
              AddKeysToAgent yes
              UseKeychain yes
            ''
            + lib.optionalString (config._1password.enable && pkgs.stdenv.isDarwin) ''
              IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
            '';
          matchBlocks = {
            "nas" = {
              hostname = "192.168.178.20";
              user = "jan";
              extraOptions = {
                preferredAuthentications = "publickey";
              };
            };
            "github.com" = {
              hostname = "github.com";
              user = "git";
              forwardAgent = false;
              forwardX11 = false;
              forwardX11Trusted = false;
              extraOptions = {
                preferredAuthentications = "publickey";
              };
            };
            "*.alcemy.tech" = {
              identityFile = "~/.ssh/id_alcemy";
            };
            "gitlab.com" = {
              hostname = "gitlab.com";
              user = "git";
              forwardAgent = false;
              forwardX11 = false;
              forwardX11Trusted = false;
              extraOptions = {
                preferredAuthentications = "publickey";
              };
            };
          };
        };
      }

      # Conditionally include the agent.toml file if 1Password is enabled
      (lib.mkIf config._1password.enable {
        home.file.".config/1Password/ssh/agent.toml".text = ''
          [[ssh-keys]]
          account = "my.1password.com"
          [[ssh-keys]]
          account = "alcemy.1password.com"
        '';
      })
    ];
  };
}
