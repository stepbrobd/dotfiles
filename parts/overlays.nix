{ ... } @ args:

let
  inherit (args) inputs;
  inherit (inputs.self) lib;
in
{
  flake.overlays.default = final: prev: lib.mkDynamicAttrs {
    dir = ../packages;
    fun = name: lib.importPackagesWith (final // { finalPkgs = final; prevPkgs = prev; }) (../packages/. + "/${name}") { };
  };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.self.overlays.default ];
    };
  };
}
