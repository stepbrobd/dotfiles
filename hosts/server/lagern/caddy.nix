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

  age.secrets.cloudflare-kichinose = {
    file = ../../../secrets/cloudflare-kichinose.age;
    owner = "caddy";
    group = "caddy";
  };

  age.secrets.cloudflare-ysun = {
    file = ../../../secrets/cloudflare-ysun.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.age.secrets.cloudflare-kichinose.path
    config.age.secrets.cloudflare-ysun.path
  ];
}
