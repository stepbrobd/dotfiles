# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  nixpkgs.config = {
    # contentAddressedByDefault = true;
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };
}
