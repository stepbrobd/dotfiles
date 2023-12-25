# nixpkgs options, host specifig

{ config
, lib
, pkgs
, ...
}:

{
  age.secrets."plausible.adm".file = ../../../secrets/plausible.adm.age;
  age.secrets."plausible.mal".file = ../../../secrets/plausible.mal.age;
  age.secrets."plausible.mmd".file = ../../../secrets/plausible.mmd.age;
  age.secrets."plausible.srv".file = ../../../secrets/plausible.srv.age;

  systemd.services.plausible.environment.MAXMIND_EDITION = "GeoLite2-City";
  systemd.services.plausible.serviceConfig.LoadCredential = [
    "MAXMIND_LICENSE_KEY:${config.age.secrets."plausible.mmd".path}"
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
}
