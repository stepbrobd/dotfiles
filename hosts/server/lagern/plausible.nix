{ config, pkgs, ... }:

{
  services.caddy.enable = true;

  age.secrets."plausible.goo".file = ../../../secrets/plausible.goo.age;
  age.secrets."plausible.mal".file = ../../../secrets/plausible.mal.age;
  age.secrets."plausible.mmd".file = ../../../secrets/plausible.mmd.age;
  age.secrets."plausible.srv".file = ../../../secrets/plausible.srv.age;

  systemd.services.plausible.serviceConfig.EnvironmentFile = [
    config.age.secrets."plausible.goo".path
    config.age.secrets."plausible.mmd".path
  ];

  services.plausible = {
    enable = true;

    package = pkgs.plausible.overrideAttrs (_: {
      prePatch = ''
        substituteInPlace lib/plausible_web/templates/layout/app.html.heex \
          --replace-warn '</head>' '<script defer data-domain="stats.ysun.co" src="/js/script.file-downloads.hash.outbound-links.js"></script></head>'
      '';
    });

    mail = {
      email = "noc@stepbrobd.com";
      smtp = {
        enableSSL = true;
        hostAddr = "smtp.purelymail.com";
        hostPort = 465;
        passwordFile = config.age.secrets."plausible.mal".path;
        user = "ysun@purelymail.com";
      };
    };

    server = {
      baseUrl = "https://stats.ysun.co";
      disableRegistration = true;
      listenAddress = "127.0.0.1";
      port = 20069;
      secretKeybaseFile = config.age.secrets."plausible.srv".path;
    };
  };

  services.caddy.virtualHosts."stats.ysun.co".extraConfig = ''
    import common
    reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
      header_up Host {host}
      header_up X-Real-IP {http.request.header.CF-Connecting-IP}
    }
  '';

  services.caddy.virtualHosts."stats.nixolo.gy".extraConfig = ''
    import common
    reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
      header_up Host {host}
      header_up X-Real-IP {http.request.header.CF-Connecting-IP}
    }
  '';

  services.caddy.virtualHosts."stats.rkt.lol".extraConfig = ''
    import common
    reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
      header_up Host {host}
      header_up X-Real-IP {http.request.header.CF-Connecting-IP}
    }
  '';
}
