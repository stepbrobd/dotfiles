{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    email = "ysun@hey.com";

    virtualHosts.${config.services.keycloak.settings.hostname}.extraConfig = ''
      import common
      reverse_proxy ${toString config.services.keycloak.settings.http-host}:${toString config.services.keycloak.settings.http-port}
    '';
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare-ysun.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.age.secrets.cloudflare.path ];
}
