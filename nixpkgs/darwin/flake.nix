{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    comma = { url = github:shopify/comma; flake = false; };
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) optionalAttrs;
      nixpkgsConfig = { config = { allowUnfree = true; }; };
    in
    {
      darwinConfigurations = rec {
        "QR2F7610Q1" = darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.StepBroBD = import ../home.nix;
            }
          ];
        };

        "C02ZQK6PMD6T" = darwinSystem {
          system = "x86_64-darwin";
          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.StepBroBD = import ../home.nix;
            }
          ];
        };
      };

      overlays = {
        comma = final: prev: {
          comma = import inputs.comma { inherit (prev) pkgs; };
        };

        apple-silicon = final: prev: optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
      };
    };
}
