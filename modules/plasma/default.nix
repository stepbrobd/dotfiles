# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.xserver = {
    enable = true;
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm.wayland.enable = true;
    };
  };

  services.power-profiles-daemon.enable = false;
}
