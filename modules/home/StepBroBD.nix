{ inputs, ... }@context:
let
  configurations = { config, lib, pkgs, ... }: {
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
      ./modules/packages.nix
      ./modules/activation.nix
    ];
  };
  homeModule = { ... }: {
    home-manager.users.StepBroBD = configurations;
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
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          configurations
        ];
      }
    ) // { inherit homeModule; }
)
