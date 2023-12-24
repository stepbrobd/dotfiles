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

    extraConfig = ''
      common {
        encode gzip zstd
        header {
          Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          X-Content-Type-Options "nosniff"
          X-Frame-Options "SAMEORIGIN"
          X-XSS-Protection "1; mode=block"
        }
      }
    '';

    virtualHosts."internal.center".extraConfig = ''
      import common
      header X-Robots-Tag "none"
      reverse_proxy ${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up X-Real-IP {remote_host}
      }
    '';

    virtualHosts."*.internal.center".extraConfig = ''
      import common
      redir https://internal.center{uri}
    '';
  };
}
