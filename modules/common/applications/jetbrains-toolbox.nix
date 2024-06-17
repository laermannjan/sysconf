{
  config,
  pkgs,
  lib,
  ...
}:
{
  options = {
    jetbrains-toolbox = {
      enable = lib.mkEnableOption {
        description = "Enable jetbrains-toolbox.";
        default = false;
      };
    };
  };

  config = lib.mkIf (!pkgs.stdenv.isDarwin && config.jetbrains-toolbox.enable) {
    unfreePackages = [ "jetbrains-toolbox" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ jetbrains-toolbox ];
    };
  };
}
