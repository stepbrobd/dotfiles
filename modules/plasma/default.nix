# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.displayManager.sddm.wayland.enable = true;

  services.power-profiles-daemon.enable = false;
}
