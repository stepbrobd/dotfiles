{ inputs, ... }@context:
let
  context = {
    inherit inputs;
  };

  configurations = import ./modules/configurations.nix;
  overlays = import ./modules/overlays.nix context;

  darwinModule = { config, lib, pkgs, ... }: {
    config.system.stateVersion = 4;

    imports = [
      configurations
      overlays
      inputs.home-manager.darwinModules.home-manager
      inputs.self.homeConfigurations.StepBroBD.homeModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        users.users.StepBroBD = {
          name = "StepBroBD";
          home = "/Users/StepBroBD";
        };
      }
    ];
  };
in
inputs.darwin.lib.darwinSystem {
  modules = [
    darwinModule
    inputs.agenix.darwinModules.default
  ];
  system = "aarch64-darwin";
}
