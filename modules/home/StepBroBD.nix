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
  inputs.utils.lib.eachSystem [
    "aarch64-darwin"
    "x86_64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ]
    (system:
      inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          homeModule
        ];
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      }
    ) // { inherit nixosModule; }
)
