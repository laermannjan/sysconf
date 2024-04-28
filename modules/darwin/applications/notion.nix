{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    notion = {
      enable = lib.mkEnableOption {
        description = "Enable Notion.";
        default = false;
      };
    };
  };
  config = lib.mkIf (config.notion.enable && pkgs.stdenv.isDarwin) {
    homebrew = {
      casks = [ "notion" ];
    };
  };
}
