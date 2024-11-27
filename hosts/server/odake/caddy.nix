{ config, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."cache.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}
    '';

    virtualHosts."hydra.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';

    virtualHosts."cache.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}
    '';

    virtualHosts."hydra.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';
  };
}
