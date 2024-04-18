{ ... } @ args:

let
  inherit (args) inputs outputs;
  inherit (outputs.lib) importPackagesWith mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }:
    {
      packages = mkDynamicAttrs {
        dir = ../packages;
        fun = name: importPackagesWith {
          inherit pkgs;
          file = (../packages/. + "/${name}");
          args = { };
        };
      };
    };

  # seems like `legacyPackages` is equivalent to `packages`?
  # https://nixos.wiki/wiki/Flakes#Output_schema
  flake.legacyPackages = outputs.packages;
}
