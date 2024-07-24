{ ... } @ args:

let
  inherit (args) inputs;
  inherit (inputs.self.lib) mapAttrs;
  configsFor = systemType: mapAttrs (n: v: v.config.system.build.toplevel) inputs.self."${systemType}Configurations";
in
{
  flake.hydraJobs = {
    inherit (inputs.self) packages devShells;
    # nixosConfigurations = configsFor "nixos";
    # darwinConfigurations = configsFor "darwin";
  };
}
