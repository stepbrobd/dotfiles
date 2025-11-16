{
  imports = [
    ./hardware.nix

    ./attic.nix
    ./hydra.nix
  ];

  services.tailscale.useRoutingFeatures = "both";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "cbef444f";
    hostName = "odake"; # https://en.wikipedia.org/wiki/Mount_Odake_(Tokyo)
    domain = "as10779.net";
  };
}
