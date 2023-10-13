# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.wpaperd = {
    enable = true;
    settings.default = {
      apply-shadow = true;
      path = ./wallpaper.jpg;
    };
  };
}
