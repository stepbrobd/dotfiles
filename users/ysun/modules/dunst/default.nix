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

        frame_width = 2;
        corner_radius = 4;
        icon_corner_radius = 4;
        progress_bar_corner_radius = 4;
        padding = 8;
        horizontal_padding = 8;
        separator_height = 2;

        background = "#2e3440";
        foreground = "#d8dee9";
        frame_color = "#4c566a";
        separator_color = "frame";
      };
    };
  };
}
