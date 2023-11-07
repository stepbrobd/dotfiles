# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  home.pointerCursor = {
    size = 24;

    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";

    gtk.enable = true;
    x11.enable = true;
  };
}
