# nixpkgs options, host specifig

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
      DOMAIN = "https://${config.networking.fqdn}";
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 10069;
      SIGNUPS_ALLOWED = false;
    };

    environmentFile = config.age.secrets.vaultwarden.path;
  };

}
