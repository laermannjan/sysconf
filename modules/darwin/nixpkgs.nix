{
  config,
  pkgs,
  lib,
  ...
}:
{
  home-manager.users.${config.user} = lib.mkIf pkgs.stdenv.isDarwin {
    programs.fish = {
      shellAbbrs = {
        nr = lib.mkForce "rebuild-darwin";
        nro = lib.mkForce "rebuild-darwin offline";
      };
      functions = {
        rebuild-darwin = {
          body = ''
            if test "$argv[1]" = "offline"
                set option "--option substitute false"
            end
            git -C ${config.sysconfPath} add --intent-to-add --all
            commandline -r "darwin-rebuild switch $option --flake ${config.sysconfPath}#${config.networking.hostName}"
            commandline --function execute
          '';
        };
        rebuild-home = lib.mkForce {
          body = ''
            git -C ${config.sysconfPath} add --intent-to-add --all
            commandline -r "${pkgs.home-manager}/bin/home-manager switch --flake ${config.sysconfPath}#${config.networking.hostName}";
            commandline --function execute
          '';
        };
      };
    };
  };
}
