{ ... } @ args:

let
  inherit (args) outputs;
  inherit (outputs.lib) mkDynamicAttrs;
in
{
  perSystem = { pkgs, ... }: {
    packages = mkDynamicAttrs {
      dir = ../packages;
      fun = name: pkgs.callPackage (../packages/. + "/${name}") {
        inherit (args) inputs outputs;
      };
    };
  };

  # seems like `legacyPackages` is equivalent to `packages`?
  # https://nixos.wiki/wiki/Flakes#Output_schema
  flake.legacyPackages = outputs.packages;
}
