{
  imports = [
    ./hardware.nix
  ];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "c20b11e0";
    hostName = "sevran"; # https://en.wikipedia.org/wiki/Sevran
    domain = "as10779.net";
  };
}
