# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    cycle = true;
    font = "Noto Sans 12";
    location = "center";
    terminal = "${config.home.sessionVariables.TERM}";

    xoffset = 0;
    yoffset = -250;

    theme = ''
    '';
  };
}
