# nixpkgs options, host specifig

{ config
, lib
, pkgs
, ...
}:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;
    package = (pkgs.callPackage ./xcaddy.nix {
      # cloudflare ipv4: https://www.cloudflare.com/ips-v4
      # cloudflare ipv6: https://www.cloudflare.com/ips-v6
      plugins = [
        "github.com/caddy-dns/cloudflare"
        "github.com/WeidiDeng/caddy-cloudflare-ip"
      ];
    });
    email = "ysun@hey.com";

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

    virtualHosts."internal.center".extraConfig = ''
      import common
      header X-Robots-Tag "none"
      reverse_proxy ${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
      }
    '';

    virtualHosts."*.internal.center".extraConfig = ''
      import common
      redir https://internal.center{uri}
    '';

    virtualHosts."stats.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
      }
    '';

    virtualHosts."ysun.co" = {
      extraConfig = ''
        import common
        reverse_proxy localhost:8000
      '';
      serverAliases = [
        "*.ysun.co"
        "as10779.net"
        "*.as10779.net"
        "churn.cards"
        "*.churn.cards"
        "metaprocessor.org"
        "*.metaprocessor.org"
        "stepbrobd.com"
        "*.stepbrobd.com"
        "xdg.sh"
        "*.xdg.sh"
        "yifei-s.com"
        "*.yifei-s.com"
        "ysun.life"
        "*.ysun.life"
      ];
    };
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare.age;
    owner = "caddy";
    group = "caddy";
  };
  systemd.services.caddy.serviceConfig = {
    AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    EnvironmentFile = [
      config.age.secrets.cloudflare.path
    ];
  };
}
