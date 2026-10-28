{ pkgs, ... }:

{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    environmentFile = "/home/kirill/.searxng.env";
    settings = {
      server = {
        port = 8888;
        bind_address = "127.0.0.1";
        secret_key = "$SEARXNG_SECRET";
      };
    };
  };
}
