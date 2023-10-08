{ config
, lib
, pkgs
, ...
}:

{
  imports = [ ./hardware.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "router";
    domain = "as10779.net";
    useDHCP = lib.mkDefault true;
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
  users.users.root.hashedPassword = "$y$j9T$WPetJSfV508KikxE9Orr8/$p54aa75AlRZOSrGNqBXYZLx/SthVzutyYSBEyn6.0n7";
}
