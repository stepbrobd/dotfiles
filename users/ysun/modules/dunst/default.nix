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
        ellipsize = true;
        alignment = "center";
        origin = "top-center";
        font = "Noto Sans 10";
        frame_width = 1;
        transparency = 5;
        corner_radius = 5;
        icon_corner_radius = 5;
        progress_bar_corner_radius = 5;
      };
    };
  };
}
