{ inputs, ... }@context:
let
  darwinModule = { config, lib, pkgs, ... }: {
    config.system.stateVersion = 4;
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.darwinModules.configurations
      inputs.self.darwinModules.overlays
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
  ];
  system = "x86_64-darwin";
}
