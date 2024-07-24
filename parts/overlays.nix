{ ... } @ args:

let
  inherit (args) inputs;
in
{
  flake.overlays.default = import ../overlays { inherit (args) inputs; };

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.self.overlays.default ];
    };
  };
}
