{ pkgs, ... }:

{
  imports = [
    ./hardware.nix

    # ./caddy.nix
    ./kanidm.nix
    # ./keycloak.nix
    # ./portunus.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "d12475e6";
    hostName = "walberla"; # https://en.wikipedia.org/wiki/Ehrenbürg
    domain = "as10779.net";
  };
}
