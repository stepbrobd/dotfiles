{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware.nix

    ./as10779.nix
    inputs.self.nixosModules.anycast
  ];

  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid = "caddy";
  };

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a7d06f05";
    hostName = "timah"; # https://en.wikipedia.org/wiki/Bukit_Timah
    domain = "as10779.net";
  };

  # temporary workaround for
  # https://github.com/tailscale/tailscale/issues/1381
  services.tailscale.package = pkgs.tailscale.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ ./tailscale-cgnat.patch ];
    doCheck = false;
  });
}
