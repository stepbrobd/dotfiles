{
  imports = [
    ./hardware.nix

    ./jitsi.nix
  ];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "ba2f1082";
    hostName = "lagern"; # https://en.wikipedia.org/wiki/Lägern
    domain = "as10779.net";
  };
}
