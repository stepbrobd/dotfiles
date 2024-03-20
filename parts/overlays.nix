{ ... } @ args:

let
  inherit (args) inputs outputs;
in
{
  flake.overlays.default = import ../overlays { inherit (args) inputs outputs; };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ outputs.overlays.default ];
    };
  };
}
