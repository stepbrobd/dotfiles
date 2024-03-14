# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.desktopManager.plasma6.enable = true;
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm.wayland.enable = true;
    };
  };

  i18n.inputMethod.fcitx5.plasma6Support = true;

  services.power-profiles-daemon.enable = false;
}
