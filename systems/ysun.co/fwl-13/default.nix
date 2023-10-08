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
  users.users.root.hashedPassword = "$y$j9T$Ed4GpkVaByUM3CGfE27k61$7dm2u5AN.MlI/amQAvJkcCFv1lL565Yj5WgW/pdYgh3";
}
