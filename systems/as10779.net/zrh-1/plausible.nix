# nixpkgs options, host specifig

{ config
, lib
, pkgs
, ...
}:

{
  age.secrets."plausible.adm".file = ../../../secrets/plausible.adm.age;
  age.secrets."plausible.mal".file = ../../../secrets/plausible.mal.age;
  age.secrets."plausible.srv".file = ../../../secrets/plausible.srv.age;

  services.plausible = {
    enable = true;

    adminUser = {
      activate = true;
      email = "ysun@hey.com";
      name = "Yifei Sun";
      passwordFile = config.age.secrets."plausible.adm".path;
    };

    mail = {
      email = "noreply@ysun.co";
      smtp = {
        enableSSL = true;
        hostAddr = "smtp-relay.gmail.com";
        hostPort = 587;
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
