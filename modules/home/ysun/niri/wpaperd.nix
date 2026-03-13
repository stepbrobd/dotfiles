{ osConfig ? { services.desktopManager.enabled = null; }, lib, ... }:

{
  config = lib.mkIf (osConfig.services.desktopManager.enabled == "niri") {
    services.wpaperd = {
      enable = true;
      settings.default = {
        apply-shadow = false;
        path = ../hyprland/wallpaper.jpg;
      };
    };
  };
}
