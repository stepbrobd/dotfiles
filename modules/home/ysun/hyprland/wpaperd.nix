{ config, lib, ... }:

{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    programs.wpaperd = {
      enable = true;
      settings.default = {
        apply-shadow = false;
        path = ./wallpaper.jpg;
      };
    };
  };
}
