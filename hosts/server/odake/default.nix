{
  imports = [
    ./hardware.nix

    ./attic.nix
    ./hydra.nix
  ];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "cbef444f";
    hostName = "odake"; # https://en.wikipedia.org/wiki/Mount_Odake_(Tokyo)
    domain = "as10779.net";
  };
}
