# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "plasma";
  environment.systemPackages = [ pkgs.xwaylandvideobridge ];

  i18n.inputMethod.fcitx5.plasma6Support = true;

  services.power-profiles-daemon.enable = false;
}
