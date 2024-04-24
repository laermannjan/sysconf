{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    _1password = {
      enable = lib.mkEnableOption {
        description = "Enable 1Password.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config._1password.enable) {
    unfreePackages = [
      "1password"
      "_1password-gui"
      "1password-cli"
    ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        _1password-gui
        _1password
      ];
    };

    # # https://1password.community/discussion/135462/firefox-extension-does-not-connect-to-linux-app
    # # On Mac, does not apply: https://1password.community/discussion/142794/app-and-browser-integration
    # # However, the button doesn't work either:
    # # https://1password.community/discussion/140735/extending-support-for-trusted-web-browsers
    # environment.etc."1password/custom_allowed_browsers".text = ''
    #   ${
    #     config.home-manager.users.${config.user}.programs.firefox.package
    #   }/Applications/Firefox.app/Contents/MacOS/firefox
    #   firefox
    # '';
  };
}
