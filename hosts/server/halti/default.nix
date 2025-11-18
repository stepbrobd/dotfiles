{
  imports = [
    ./hardware.nix

    ./grafana.nix
    # ./tangled.nix
  ];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a4c7c5aa";
    hostName = "halti";
    domain = "as10779.net";
  };
}
