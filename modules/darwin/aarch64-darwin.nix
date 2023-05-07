{ inputs, ... }@context:
let
  darwinModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.darwinModules.default
      inputs.self.darwinModules.overlay
      inputs.self.homeConfigurations.StepBroBD.nixosModule
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
    config = {
      system = {
        stateVersion = 4;
      };
    };
  };
in
inputs.darwin.lib.darwinSystem {
  modules = [
    darwinModule
  ];
  system = "aarch64-darwin";
}
