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

    # idk what package is depending on electron-25.9.0
    permittedInsecurePackages = [ "electron-25.9.0" ];
  };
}
