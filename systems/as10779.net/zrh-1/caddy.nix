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

    virtualHosts.${config.networking.fqdn}.extraConfig = ''
      encode gzip

      header / {
        Strict-Transport-Security "max-age=31536000;"
        X-XSS-Protection "0"
        X-Frame-Options "SAMEORIGIN"
        X-Robots-Tag "noindex, nofollow"
        X-Content-Type-Options "nosniff"
        -Server
        -X-Powered-By
        -Last-Modified
      }

      reverse_proxy ${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up X-Real-IP {remote_host}
      }
    '';
  };
}
