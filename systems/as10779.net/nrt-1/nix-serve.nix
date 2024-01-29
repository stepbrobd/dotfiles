# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  age.secrets.cache = {
    file = ../../../secrets/cache.pem.age;
    owner = "nix-serve";
    mode = "0400";
  };

  services.nix-serve = {
    enable = true;
    bindAddress = "127.0.0.1";
    port = 10070;
    secretKeyFile = config.age.secrets.cache.path;
  };
}
