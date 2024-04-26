{
  config,
  pkgs,
  lib,
  ...
}: {

  options = {
    meetingbar = {
      enable = lib.mkEnableOption {
        description = "Enable MeetingBar.";
        default = false;
      };
    };
  };
  config = lib.mkIf pkgs.stdenv.isDarwin {
    homebrew = {
      casks = ["meetingbar"];
    };
  };
}

