{ inputs, ... }@context:
let
  homeModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.self.homeModules.default
      inputs.self.homeModules.pkgs
      inputs.self.homeModules.activation
    ];
    config = {
      home = {
        stateVersion = "23.05";
      };
    };
  };
  nixosModule = { ... }: {
    home-manager.users.StepBroBD = homeModule;
  };
in
(
  (
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        homeModule
      ];
      # FIX: should be different in different host platforms, either put this in darwinConfigurations or make it function like `builtins.currentSystem`
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
    }
  ) // { inherit nixosModule; }
)
