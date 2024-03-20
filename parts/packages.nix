{ ... } @ args:

let
  inherit (args.outputs.lib) mkDynamicAttrs;
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
}
