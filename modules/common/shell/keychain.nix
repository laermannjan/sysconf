{ lib, config, ... }:

# keychain is an ssh-agent manager that integerates with the PAM and handles agents across shell sesssions
{
  options = {
    keychain = {
      enable = lib.mkEnableOption {
        description = "Enable keychain";
        default = true;
      };
      keys = lib.mkOption {
        description = "List of private ssh keys to be managed by keychain.";
        default = [ ];
      };
    };
  };

  config = lib.mkIf (config.keychain.enable) {
    home-manager.users.${config.user} = {
      programs.keychain = {
        enable = if config._1password.enableSshAgent then false else true;
        enableFishIntegration = lib.mkDefault true;
        keys = config.keychain.keys;
      };
    };
  };

}
