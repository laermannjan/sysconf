{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    notion-calendar = {
      enable = lib.mkEnableOption {
        description = "Enable Notion Calendar.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.notion-calendar.enable && pkgs.stdenv.isDarwin) {
    homebrew = {
      casks = [ "notion-calendar" ];
    };
  };
}
