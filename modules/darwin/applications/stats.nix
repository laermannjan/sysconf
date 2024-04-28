{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    stats = {
      enable = lib.mkEnableOption {
        description = "Enable Stats.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.stats.enable && pkgs.stdenv.isDarwin) {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      monitorcontrol
      utm # VM software that's able to create macOS vms
      stats # menu bar system inidactors
    ];
  };
}
