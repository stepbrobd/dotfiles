{ lib, inputs, ... }:

{
  flake.overlays.default = final: prev: lib.mkDynamicAttrs {
    dir = ../pkgs;
    fun = name: lib.importPackagesWith (final // { inherit inputs; pkgsFinal = final; pkgsPrev = prev; }) (../pkgs/. + "/${name}") { };
  };
}
