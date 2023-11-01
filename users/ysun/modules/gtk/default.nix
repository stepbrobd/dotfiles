# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  gtk = {
    enable = true;

    theme = {
      package = pkgs.nordic;
      name = "Nordic";
    };
  };
}
