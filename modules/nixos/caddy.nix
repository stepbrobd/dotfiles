# custom options

{ config
, lib
, pkgs
, ...
}:

{
  services.caddy = {
    # from overlay
    package = pkgs.pcaddy.override {
      # cloudflare ipv4: https://www.cloudflare.com/ips-v4
      # cloudflare ipv6: https://www.cloudflare.com/ips-v6
      plugins = [
        "github.com/caddy-dns/cloudflare"
        "github.com/WeidiDeng/caddy-cloudflare-ip"
      ];
    };

    globalConfig = ''
      servers {
        trusted_proxies cloudflare {
          interval 24h
          timeout 60s
        }
      }
    '';

    extraConfig = ''
      (common) {
        tls {
          dns cloudflare {env.CF_API_EMAIL_YSUN} {env.CF_API_TOKEN_YSUN}
          dns cloudflare {env.CF_API_EMAIL_KICHINOSE} {env.CF_API_TOKEN_KICHINOSE}
        }
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

  systemd.services.caddy.serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
}
