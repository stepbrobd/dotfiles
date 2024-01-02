# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  age.secrets.vaultwarden.file = ../../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;

    config = {
      DOMAIN = "https://internal.center";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 10069;
      SIGNUPS_ALLOWED = false;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };
}
