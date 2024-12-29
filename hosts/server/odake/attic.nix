{ config, pkgs, ... }:

{
  services.attic = {
    enable = true;
    settings.listen = "127.0.0.1:10070";
  };

  services.caddy = {
    enable = true;

    virtualHosts."cache.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${config.services.attic.settings.listen}
    '';
  };
}
