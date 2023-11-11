# nixpkgs options, host specifig

{ config
, lib
, pkgs
, ...
}:

{
  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = config.networking.fqdn;
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 6969;
      SIGNUPS_ALLOWED = false;
    };
  };

  services.caddy = {
    enable = true;

    virtualHosts.${config.networking.fqdn}.extraConfig = ''
      header {
      }

      reverse_proxy ${config.services.vaultwarden.config.ROCKET_ADDRESS}:${config.services.vaultwarden.config.ROCKET_PORT} {
        header_up Host {host}
        header_up X-Real-IP {remote}
        header_up X-Forwarded-For {remote}
        header_up X-Forwarded-Proto {scheme}
        header_up X-Forwarded-Host {host}
        header_up X-Forwarded-Port {port}
      }
    '';
  };
}
