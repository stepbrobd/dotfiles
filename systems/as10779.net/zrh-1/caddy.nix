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
      plugins = [ "github.com/caddy-dns/cloudflare" ];
    });

    extraConfig = ''
      (common) {
        tls { dns cloudflare {env.CF_API_TOKEN} }
        encode gzip zstd
        header {
          Content-Security-Policy "default-src 'self'; img-src 'self' data:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; frame-ancestors https://ysun.co"
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
        header_up X-Real-IP {remote_host}
      }
    '';

    virtualHosts."stats.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
        header_up Host {host}
        header_up X-Real-IP {remote_host}
      }
    '';
  };

  age.secrets.cloudflare.file = ../../../secrets/cloudflare.age;
  systemd.services.caddy.serviceConfig.LoadCredential = [
    "CF_API_TOKEN:${config.age.secrets.cloudflare.path}"
  ];
}
