{ ... } @ args:

let
  inherit (args) inputs;
  inherit (inputs.self.lib) importPackagesWith mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }:
    {
      packages = mkDynamicAttrs {
        dir = ../packages;
        fun = name: importPackagesWith pkgs (../packages/. + "/${name}") { };
      };
    };

  # seems like `legacyPackages` is equivalent to `packages`?
  # https://nixos.wiki/wiki/Flakes#Output_schema
  flake.legacyPackages = inputs.self.packages;
}
