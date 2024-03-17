# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.nushell = {
    enable = true;
  };
}
