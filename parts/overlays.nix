{ lib, inputs, ... }:

{
  flake.overlays.default = final: prev: lib.mkDynamicAttrs {
    dir = ../packages;
    fun = name: lib.importPackagesWith (final // { inherit inputs; pkgsFinal = final; pkgsPrev = prev; }) (../packages/. + "/${name}") { };
  };
}
