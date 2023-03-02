{ inputs, ... }@flakeContext:
let
  darwinModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      inputs.self.darwinModules.default
      inputs.self.darwinModules.overlays
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
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    darwinModule
  ];
  system = "aarch64-darwin";
}
