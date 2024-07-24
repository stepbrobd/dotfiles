# haumea args
{ inputs }:

# importPackagesWith args
pkgs: pkg: args:

let
  callPackage = pkgs.lib.callPackageWith pkgs;
in
callPackage pkg args
