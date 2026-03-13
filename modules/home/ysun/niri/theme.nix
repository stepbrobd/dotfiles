{ osConfig ? { services.desktopManager.enabled = null; }, lib, pkgs, ... }:

{
  config = lib.mkIf (osConfig.services.desktopManager.enabled == "niri") {
    gtk = {
      enable = true;

      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };

      cursorTheme = {
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
        size = 24;
      };
    };

    home.pointerCursor = {
      size = 24;

      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";

      gtk.enable = true;
      x11.enable = true;
    };
  };
}
