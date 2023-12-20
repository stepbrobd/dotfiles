# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
  };
}
