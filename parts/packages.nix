{ lib, inputs, ... }:

let
  inherit (lib) importPackagesWith mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }:
    {
      packages = mkDynamicAttrs {
        dir = ../packages;
        fun = name: importPackagesWith (pkgs // { inherit inputs lib; }) (../packages/. + "/${name}") { };
      };
    };

  # seems like `legacyPackages` is equivalent to `packages`?
  # https://nixos.wiki/wiki/Flakes#Output_schema
  flake.legacyPackages = inputs.self.packages;
}
