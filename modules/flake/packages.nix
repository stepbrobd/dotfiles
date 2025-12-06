{ lib, ... }:

let
  inherit (lib) attrNames genAttrs pipe readDir;
in
{
  perSystem = { pkgs, ... }: {
    packages = genAttrs
      (pipe ../../pkgs [ readDir attrNames ])
      (name: pkgs.${name});
  };
}
