{ ... }:

{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    extraConfig = ''
      IgnoreUnknown AddKeysToAgent,UseKeychain
      AddKeysToAgent yes
      UseKeychain yes
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
    matchBlocks = {
      "nas" = {
        hostname = "192.168.178.20";
        identityFile = "~/.ssh/id_ed25519";
        user = "jan";
        identitiesOnly = true;
        extraOptions = { preferredAuthentications = "publickey"; };
      };
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        user = "git";
        forwardAgent = false;
        forwardX11 = false;
        forwardX11Trusted = false;
        extraOptions = { preferredAuthentications = "publickey"; };
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = [ "~/.ssh/id_alcemy" "~/.ssh/id_ed25519" ];
        identitiesOnly = true;
        user = "git";
        forwardAgent = false;
        forwardX11 = false;
        forwardX11Trusted = false;
        extraOptions = { preferredAuthentications = "publickey"; };
      };
    };
  };
  home.file.".config/1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    account = "my.1password.com"
    [[ssh-keys]]
    account = "alcemy.1password.com"
  '';
}
