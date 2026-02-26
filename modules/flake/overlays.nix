{ inputs, lib, ... }:

{
  flake.overlays.default = pkgsFinal: pkgsPrev: lib.importPackagesTree {
    dir = ../../pkgs;

    currentFinal = pkgsFinal;
    currentPrev = pkgsPrev;

    inheritedArgs = {
      inherit
        inputs
        lib
        pkgsFinal
        pkgsPrev
        ;
    };
  };
}
