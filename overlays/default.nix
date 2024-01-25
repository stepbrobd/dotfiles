{ lib }:

final: prev: lib.mkDynamicAttrs {
  dir = ../packages;
  fun = name: final.callPackage (../packages/. + "/${name}") { };
}
