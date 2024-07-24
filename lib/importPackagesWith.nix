# haumea args
{ inputs }:

# importPackagesWith args
pkgs: pkg: args:

let
  inherit (pkgs.lib) callPackageWith;
  callPackage = callPackageWith (pkgs // { inherit inputs; });
in
callPackage pkg args
