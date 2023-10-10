# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        sort = true;
        origin = "top-right";
        ellipsize = true;
        frame_width = 1;
        transparency = 5;
        corner_radius = 5;
        icon_corner_radius = 5;
        progress_bar_corner_radius = 5;
      };
    };
  };
}
