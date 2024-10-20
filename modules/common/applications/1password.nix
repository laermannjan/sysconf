{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config._1password;

in

{
  options = {
    _1password = {
      enable = lib.mkEnableOption {
        description = "Enable 1Password.";
        default = false;
      };
      enableSshAgent = lib.mkEnableOption {
        description = "Enable 1Password ssh-agent";
        default = false;
      };
      enableFishIntegration = lib.mkEnableOption {
        description = "Fish integration";
        default = true;
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
      home.packages =
        let
          packages =
            with pkgs;
            if pkgs.stdenv.isDarwin then
              [ _1password ]
            else
              [
                _1password-gui
                _1password
              ];
        in
        packages;

      xdg.configFile."op/plugins.sh".text = ''
        export OP_PLUGIN_ALIASES_SOURCED=1
        alias aws="op plugin run -- aws"
        alias glab="op plugin run -- glab"
      '';
    };

    programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration (
      lib.mkMerge [
        # First block for op completion
        (lib.mkAfter ''
          if command -q op
              op completion fish | source
              source ~/.config/op/plugins.sh
          end

          if test -f ~/.cache/GITLAB_ACCESS_TOKEN
              set -gx GITLAB_ACCESS_TOKEN (cat ~/.cache/GITLAB_ACCESS_TOKEN)
          else
              set -gx GITLAB_ACCESS_TOKEN (op read "op://private/GitLab Personal Access Token/token")
              echo $GITLAB_ACCESS_TOKEN > ~/.cache/GITLAB_ACCESS_TOKEN
          end
        '')

        # Conditional block for 1password SSH agent
        (lib.mkIf cfg.enableSshAgent.enable (
          lib.mkAfter ''
            # Allow 1password-cli ssh-agent to see which keys are available
            # `ssh-add -l` will now show all available ssh-keys from 1password
            set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
          ''
        ))
      ]
    );
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
