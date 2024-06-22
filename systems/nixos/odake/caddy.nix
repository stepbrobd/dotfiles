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

    virtualHosts."cache.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}
    '';

    virtualHosts."hydra.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';
  };

  age.secrets.cloudflare = {
    file = ../../../secrets/cloudflare-ysun.age;
    owner = "caddy";
    group = "caddy";
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.age.secrets.cloudflare.path ];
}
