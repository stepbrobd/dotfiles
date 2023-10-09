# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.waybar = {
    enable = true;
  };
}
