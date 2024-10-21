{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    email = "ysun@hey.com";

    virtualHosts.${config.services.kanidm.serverSettings.domain}.extraConfig = ''
      import common
      reverse_proxy https://${toString config.services.kanidm.serverSettings.bindaddress}
    '';
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare-ysun.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.age.secrets.cloudflare.path ];
}
