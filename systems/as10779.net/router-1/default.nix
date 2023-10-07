{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./hardware.nix

    ../../../modules/direnv
    ../../../modules/git
    ../../../modules/neovim
    ../../../modules/nix
    ../../../modules/nixpkgs
  ];

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

    curl
    wget
  ];
}
