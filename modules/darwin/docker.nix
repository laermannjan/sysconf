{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    docker = {
      enable = lib.mkEnableOption {
        description = "Enable Docker.";
        default = false;
      };
    };
  };
  config = lib.mkIf (pkgs.stdenv.isDarwin && config.docker.enable) {
    homebrew.casks = [ "docker" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ lazydocker ];
    };
  };
}
