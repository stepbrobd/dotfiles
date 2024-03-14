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
        shrink = "no";
        markup = "yes";
        transparency = 0;
        ellipsize = true;
        alignment = "center";
        origin = "top-center";
        font = "Noto Sans 10";

        separator_height = 4;
        frame_width = 2;
        padding = 8;
        horizontal_padding = 8;
        corner_radius = 8;
        icon_corner_radius = 8;
        progress_bar_corner_radius = 8;

        background = "#2e3440";
        foreground = "#d8dee9";
        frame_color = "#4c566a";
        separator_color = "frame";
      };
    };
  };
}
