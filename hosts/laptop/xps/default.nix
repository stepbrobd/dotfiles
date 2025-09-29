{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Paris";

  services.openssh.enable = true;

  services.desktopManager.enabled = "niri";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "a39d07b7";
    hostName = "xps";
    domain = "ysun.co";
    networkmanager.enable = true;
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
    curlHTTP3
    wget
  ];

  users.mutableUsers = false;

  # nix.nixbuild.enable = true;
}
