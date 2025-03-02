{ config, lib, ... }:

{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    services.wpaperd = {
      enable = true;
      settings.default = {
        apply-shadow = false;
        path = ./wallpaper.jpg;
      };
    };
  };
}
