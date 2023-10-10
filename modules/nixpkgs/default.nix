# nixpkgs + nix-darwin options

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
