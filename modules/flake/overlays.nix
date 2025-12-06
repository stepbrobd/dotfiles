{ inputs, lib, ... }:

let
  inherit (lib) fix importPackagesWith mkDynamicAttrs;
in
{
  flake.overlays.default =
    pkgsFinal: pkgsPrev:
    mkDynamicAttrs (
      fix (self: {
        dir = ../../pkgs;
        fun =
          name:
          importPackagesWith
            (
              pkgsFinal
              // {
                inherit
                  inputs
                  lib
                  pkgsFinal
                  pkgsPrev
                  ;
              }
            )
            (self.dir + "/${name}")
            { };
      })
    );
}
