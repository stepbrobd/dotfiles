# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };
}
