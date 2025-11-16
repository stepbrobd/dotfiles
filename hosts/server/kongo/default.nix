{ inputs, ... }:

{
  imports = [
    ./hardware.nix

    ./as10779.nix
    inputs.self.nixosModules.anycast
  ];

  services.tailscale.useRoutingFeatures = "both";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "f222f0f0";
    hostName = "kongo"; # https://en.wikipedia.org/wiki/Mount_Kongō
    domain = "as10779.net";
  };
}
