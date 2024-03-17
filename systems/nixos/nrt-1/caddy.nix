# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;

    # from overlay
    package = pkgs.pcaddy.override {
      # cloudflare ipv4: https://www.cloudflare.com/ips-v4
      # cloudflare ipv6: https://www.cloudflare.com/ips-v6
      plugins = [
        "github.com/caddy-dns/cloudflare"
        "github.com/WeidiDeng/caddy-cloudflare-ip"
      ];
    };

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

    virtualHosts."cache.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}
    '';

    virtualHosts."hydra.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare.age;
    owner = "caddy";
    group = "caddy";
  };
  systemd.services.caddy.serviceConfig = {
    AmbientCapabilities = "CAP_NET_BIND_SERVICE";
    EnvironmentFile = [ config.age.secrets.cloudflare.path ];
  };
}
