{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    email = "ysun@hey.com";
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare-ysun.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.age.secrets.cloudflare.path ];
}
