# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.caddy = {
    enable = true;
    email = "ysun@hey.com";

    virtualHosts."nixolo.gy" = {
      extraConfig = ''
        import common
        redir https://github.com/stepbrobd/nixology/tree/master{uri}
      '';
      serverAliases = [ "*.nixolo.gy" ];
    };
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.age.secrets.cloudflare.path ];
}
