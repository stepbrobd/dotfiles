# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.xserver.desktopManager.plasma6 = {
    enable = true;
  };
}
