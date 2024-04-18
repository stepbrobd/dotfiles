# haumea args
{ inputs, outputs }:

# importPackagesWith args
{ pkgs, file, args }:

let
  inherit (pkgs.lib) callPackageWith;
  callPackage = callPackageWith (pkgs // { inherit inputs outputs; });
in
callPackage file args
