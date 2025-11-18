{
  imports = [
    ./hardware.nix

    ./glance.nix
    ./golink.nix
    ./kanidm.nix
  ];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "d12475e6";
    hostName = "walberla"; # https://en.wikipedia.org/wiki/Ehrenbürg
    domain = "as10779.net";
  };
}
