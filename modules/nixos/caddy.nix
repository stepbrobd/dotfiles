{ inputs, lib, ... }:

{ config, pkgs, ... }:

{
  config = lib.mkIf (config.services.caddy.enable) {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
      # from overlay
      package = pkgs.pcaddy.override {
        # cloudflare ipv4: https://www.cloudflare.com/ips-v4
        # cloudflare ipv6: https://www.cloudflare.com/ips-v6
        plugins = [
          "github.com/WeidiDeng/caddy-cloudflare-ip"
          "github.com/caddy-dns/cloudflare"
          "github.com/caddyserver/replace-response"
        ];
      };

      email = "ysun@hey.com";

      globalConfig = ''
        admin off
        order replace after encode

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

    age.secrets.cloudflare = {
      file = "${inputs.self.outPath}/secrets/cloudflare-caddy.age";
      owner = config.services.caddy.user;
      group = config.services.caddy.group;
    };

    systemd.services.caddy.serviceConfig = {
      EnvironmentFile = [ config.age.secrets.cloudflare.path ];
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    };
  };
}
