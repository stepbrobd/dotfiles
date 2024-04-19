# haumea args
{ inputs, outputs }:

# importPackagesWith args
pkgs: pkg: args:

let
  inherit (pkgs.lib) callPackageWith;
  callPackage = callPackageWith (pkgs // { inherit inputs outputs; });
in
callPackage pkg args
