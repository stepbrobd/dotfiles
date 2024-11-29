{ inputs, lib, ... }:

{ config, pkgs, ... }:

{
  config = lib.mkIf (config.services.caddy.enable) {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    services.caddy = {
      # blocked on nixpkgs #358586
      # package = pkgs.caddy.withPlugins {
      #   hash = "sha256-h8mPpbuhs/n3oOdXzDWMr5x8wlP2a1W4PHOIwKItyJo=";
      #   plugins = [
      #     "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb"
      #     "github.com/caddy-dns/cloudflare@v0.0.0-20240703190432-89f16b99c18e"
      #     "github.com/caddyserver/replace-response@v0.0.0-20240710174758-f92bc7d0c29d"
      #   ];
      # };
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
