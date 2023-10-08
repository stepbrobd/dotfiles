{ config
, lib
, pkgs
, ...
}:

{
  imports = [ ./hardware.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  networking = {
    hostName = "fwl-13";
    domain = "ysun.co";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  environment.systemPackages = with pkgs; [
    cacert
    sbctl

    coreutils
    inetutils
    dnsutils
    pciutils
    binutils

    direnv
    nix-direnv
    vim
    git
    curl
    wget
  ];

  users.mutableUsers = false;
}
