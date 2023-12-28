# nixpkgs options, host specifig

{ config
, lib
, pkgs
, ...
}:

{
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
