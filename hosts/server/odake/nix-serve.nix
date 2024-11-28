{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."cache.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}
    '';

    virtualHosts."cache.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}
    '';
  };

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
