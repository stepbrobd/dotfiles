{ lib, ... }:

{ config, pkgs, ... }:

{
  config = lib.mkIf config.services.caddy.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
      enableReload = config.services.caddy.enable;
      package = pkgs.caddy-with-plugins;
      email = "ysun@hey.com";

      globalConfig = ''
        admin unix/${config.services.caddy.dataDir}/admin.sock

        servers {
          trusted_proxies cloudflare {
            interval 24h
            timeout 60s
          }
        }
      '';

      extraConfig = ''
        (common) {
          tls { dns cloudflare {env.CF_API_TOKEN} }
          encode gzip zstd
          header {
            Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
            X-Content-Type-Options "nosniff"
            X-XSS-Protection "1; mode=block"
            -Last-Modified
            -Server
            -X-Powered-By
          }
        }
      '';
    };

    sops.secrets.caddy = {
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };

    systemd.services.caddy.serviceConfig = {
      EnvironmentFile = [ config.sops.secrets.caddy.path ];
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };
}
