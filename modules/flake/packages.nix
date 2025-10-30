{ lib, inputs, ... }:

let
  inherit (lib) importPackagesWith mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }:
    {
      packages = mkDynamicAttrs rec {
        dir = ../../pkgs;
        fun = name: importPackagesWith (pkgs // { inherit inputs lib; }) (dir + "/${name}") { };
      };
    };

  # seems like `legacyPackages` is equivalent to `packages`?
  # https://nixos.wiki/wiki/Flakes#Output_schema
  flake.legacyPackages = inputs.self.packages;
}
