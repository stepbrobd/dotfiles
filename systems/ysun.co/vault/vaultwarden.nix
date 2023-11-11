# nixpkgs options, host specifig

{ config
, lib
, pkgs
, ...
}:

{
  age.secrets.vaultwarden.file = ../../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = "https://${config.networking.fqdn}";
      ROCKET_ADDRESS = "::1";
      ROCKET_PORT = 6969;
      SIGNUPS_ALLOWED = false;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

  services.fail2ban = {
    enable = true;

    jails = {
      vaultwarden = ''
        enabled = true
        filter = vaultwarden
        port = 80,443,8000
        maxretry = 5
      '';

      vaultwarden-admin = ''
        enabled = true
        port = 80,443
        filter = vaultwarden-admin
        maxretry = 3
        bantime = 14400
        findtime = 14400
      '';
    };
  };

  environment.etc = {
    "fail2ban/filter.d/vaultwarden.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=vaultwarden.service
    '';

    "fail2ban/filter.d/vaultwarden-admin.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=vaultwarden.service
    '';
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.caddy = {
    enable = true;

    virtualHosts.${config.networking.fqdn}.extraConfig = ''
      reverse_proxy ${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
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
