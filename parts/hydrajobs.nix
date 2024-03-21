{ ... } @ args:

let
  inherit (args) outputs;
  inherit (outputs.lib) mapAttrs;
  configsFor = systemType: mapAttrs (n: v: v.config.system.build.toplevel) outputs."${systemType}Configurations";
in
{
  flake.hydraJobs = {
    inherit (outputs) packages devShells;
    # nixosConfigurations = configsFor "nixos";
    # darwinConfigurations = configsFor "darwin";
  };
}
