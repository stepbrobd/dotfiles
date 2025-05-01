{ lib, ... }:

{ config, pkgs, ... }:

{
  config = lib.mkIf config.services.calibre-web.enable {
    services.calibre-web = {
      package = pkgs.calibre-web.overrideAttrs (final: prev: {
        patches = prev.patches ++ [ ./header-and-stats.patch ];
      });

      listen.ip = "127.0.0.1";
      listen.port = 8083;

      dataDir = "/var/lib/calibre-web";
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        reverseProxyAuth.enable = true;
        calibreLibrary = "${config.services.calibre-web.dataDir}/books";
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."read.ysun.co".extraConfig =
        with config.services.calibre-web.listen ;
        ''
          import common
          header >Content-Security-Policy (.*) "$1; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://stats.ysun.co https://static.cloudflareinsights.com;"
          reverse_proxy ${ip}:${lib.toString port}
        '';
    };
  };
}
