# nixpkgs module, import directly to system settings

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
