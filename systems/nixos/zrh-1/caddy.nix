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

    virtualHosts."internal.center".extraConfig = ''
      import common
      header X-Robots-Tag "none"
      reverse_proxy ${toString config.services.vaultwarden.config.ROCKET_ADDRESS}:${toString config.services.vaultwarden.config.ROCKET_PORT} {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
      }
    '';

    virtualHosts."*.internal.center".extraConfig = ''
      import common
      redir https://internal.center{uri}
    '';

    virtualHosts."stats.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
      }
    '';

    virtualHosts."ysun.co" = {
      extraConfig = ''
        import common
        reverse_proxy localhost:8000
      '';
      serverAliases = [
        "*.ysun.co"
        "as10779.net"
        "*.as10779.net"
        "churn.cards"
        "*.churn.cards"
        "metaprocessor.org"
        "*.metaprocessor.org"
        "stepbrobd.com"
        "*.stepbrobd.com"
        "xdg.sh"
        "*.xdg.sh"
        "yifei-s.com"
        "*.yifei-s.com"
        "ysun.life"
        "*.ysun.life"
      ];
    };
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.age.secrets.cloudflare.path ];
}
