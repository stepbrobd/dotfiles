{ lib, ... }:

{
  imports = [
    ./hardware.nix
  ];

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "b82f0f98";
    hostName = "isere"; # https://en.wikipedia.org/wiki/Isère_(river)
    domain = "as10779.net";
  };

  services.caddy.enable = lib.mkForce false;
  services.prometheus.enable = lib.mkForce false;
  services.geoipupdate.enable = lib.mkForce false;
}
