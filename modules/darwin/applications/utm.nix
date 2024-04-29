{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    utm = {
      enable = lib.mkEnableOption {
        description = "Enable utm.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.utm.enable && pkgs.stdenv.isDarwin) {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      utm # VM software that's able to create macOS vms
    ];
  };
}
