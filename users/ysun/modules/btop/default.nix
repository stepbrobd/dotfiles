# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.btop = {
    enable = true;
  };
}
