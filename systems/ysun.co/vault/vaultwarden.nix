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
      ROCKET_PORT = 10069;
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
