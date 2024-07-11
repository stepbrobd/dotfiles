# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  age.secrets."plausible.adm".file = ../../../secrets/plausible.adm.age;
  age.secrets."plausible.goo".file = ../../../secrets/plausible.goo.age;
  age.secrets."plausible.mal".file = ../../../secrets/plausible.mal.age;
  age.secrets."plausible.mmd".file = ../../../secrets/plausible.mmd.age;
  age.secrets."plausible.srv".file = ../../../secrets/plausible.srv.age;

  systemd.services.plausible.serviceConfig.EnvironmentFile = [
    config.age.secrets."plausible.goo".path
    config.age.secrets."plausible.mmd".path
  ];

  # enabled by default: https://plausible.io/docs/self-hosting-configuration#ip-geolocation
  # systemd.services.plausible.environment.GEONAMES_SOURCE_FILE = builtins.fetchurl {
  #   url = "https://raw.githubusercontent.com/plausible/location/main/priv/geonames.lite.csv";
  #   sha256 = "sha256-vZuFZYYt7yThPj5dwfScz/5LKESa4zOHw37xQA4pU24=";
  # };

  services.plausible = {
    enable = true;

    adminUser = {
      activate = true;
      email = "ysun@hey.com";
      name = "Yifei Sun";
      passwordFile = config.age.secrets."plausible.adm".path;
    };

    mail = {
      email = "noreply@stepbrobd.com";
      smtp = {
        enableSSL = true;
        hostAddr = "smtp-relay.gmail.com";
        hostPort = 465;
        passwordFile = config.age.secrets."plausible.mal".path;
        user = "ysun@stepbrobd.com";
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
    replace re "<head>.*</head>" `<head>$1<script defer data-domain="stats.ysun.co" src="https://stats.ysun.co/js/script.file-downloads.hash.outbound-links.js"></script></head>`
  '';

  services.caddy.virtualHosts."toukei.ikaz.uk".extraConfig = ''
    import common
    tls { dns cloudflare {env.CF_API_TOKEN_KICHINOSE} }
    reverse_proxy ${toString config.services.plausible.server.listenAddress}:${toString config.services.plausible.server.port} {
      header_up Host {host}
      header_up X-Real-IP {http.request.header.CF-Connecting-IP}
    }
    replace re "<head>.*</head>" `<head>$1<script defer data-domain="stats.ysun.co" src="https://toukei.ikaz.uk/js/script.file-downloads.hash.outbound-links.js"></script></head>`
  '';
}
