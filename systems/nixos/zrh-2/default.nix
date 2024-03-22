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

    ./caddy.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Etc/UTC";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "bd4f630f";
    hostName = "zrh-2";
    domain = "as10779.net";
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
