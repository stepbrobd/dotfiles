{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  imports = [
    ./hardware.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Etc/UTC";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "cbef444f";
    hostName = "nrt-1";
    domain = "as10779.net";
  };

  services.tailscale.useRoutingFeatures = "server";

  environment.systemPackages = with pkgs; [
    cacert

    coreutils
    inetutils
    dnsutils

    direnv
    nix-direnv
    vim
    git
    curl
    wget
  ];

  users.mutableUsers = false;
}
