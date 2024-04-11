# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  # currently disabled, switched to 1Password

  age.secrets.vaultwarden.file = ../../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = "https://internal.center";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 10069;
      SIGNUPS_ALLOWED = false;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

  services.caddy.virtualHosts = {
    "internal.center".extraConfig = ''
      import common
      header X-Robots-Tag "none"
      reverse_proxy ${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
      }
    '';

    "*.internal.center".extraConfig = ''
      import common
      redir https://internal.center{uri}
    '';
  };

  services.fail2ban = {
    enable = true;

    jails = {
      vaultwarden = ''
        enabled = true
        filter = vaultwarden
        port = 80,443
        maxretry = 5
      '';

      vaultwarden-admin = ''
        enabled = true
        port = 80,443
        filter = vaultwarden-admin
        maxretry = 3
        bantime = 86400
        findtime = 86400
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
}
