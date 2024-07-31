{ inputs, ... }:

let
  # colmena #161
  mkColmenaFromNixOSConfigurations = conf:
    {
      meta = {
        # description = "my personal machines";
        nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };

        nodeNixpkgs = builtins.mapAttrs (_: value: value.pkgs) conf;

        nodeSpecialArgs = builtins.mapAttrs (_: value: value._module.specialArgs) conf;
      };
    } // builtins.mapAttrs (_: value: { imports = value._module.args.modules; }) conf;
in
{
  flake.colmena = mkColmenaFromNixOSConfigurations inputs.self.nixosConfigurations;
}
