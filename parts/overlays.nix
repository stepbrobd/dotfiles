{ lib, inputs, ... }:

{
  flake.overlays.default = final: prev: lib.mkDynamicAttrs {
    dir = ../packages;
    fun = name: lib.importPackagesWith (final // { inherit inputs; finalPkgs = final; prevPkgs = prev; }) (../packages/. + "/${name}") { };
  };
}
