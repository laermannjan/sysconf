{ ... }:
{
  programs.nixvim.plugins = {
    neotest = {
      enable = true;
      adapters = {
        go.enable = true;
        python.enable = true;
        rust.enable = true;
      };
    };
  };
}
