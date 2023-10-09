{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  imports = [ ./hardware.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  networking = {
    # head -c4 /dev/urandom | od -A none -t x4
    hostId = "169b9f98";
    hostName = "fwl-13";
    domain = "ysun.co";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  programs.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
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
