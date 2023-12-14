{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./hardware.nix
    ./bird2.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "EtC/UTC";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "5d7847f2";
    hostName = "lax1";
    domain = "as10779.net";
    networkmanager.enable = true;
    firewall.enable = true;
  };

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
