{ inputs, ... }@context:
let
  homeModule = { config, lib, pkgs, ... }: {
    config.home.stateVersion = "23.05";

    config.programs = {
      home-manager = {
        enable = true;
      };
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    imports = [
      inputs.self.homeModules.packages
      inputs.self.homeModules.activation
    ];
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
