{
  description = "StepBroBD";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "flake:nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "flake:home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-overlay = {
      url = "github:stepbrobd/vscode-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    raycast-overlay = {
      url = "github:stepbrobd/raycast-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      flakeContext = {
        inherit inputs;
      };
    in
    {
      darwinConfigurations = {
        aarch64-darwin = import ./modules/darwinConfigurations/aarch64-darwin.nix flakeContext;
        x86_64-darwin = import ./modules/darwinConfigurations/x86_64-darwin.nix flakeContext;
      };
      darwinModules = {
        default = import ./modules/darwinModules/default.nix flakeContext;
        overlay = import ./modules/darwinModules/overlay.nix flakeContext;
      };
      homeConfigurations = {
        StepBroBD = import ./modules/homeConfigurations/StepBroBD.nix flakeContext;
      };
      homeModules = {
        activation = import ./modules/homeModules/activation.nix flakeContext;
        default = import ./modules/homeModules/default.nix flakeContext;
        package-darwin = import ./modules/homeModules/package-darwin.nix flakeContext;
        package-linux = import ./modules/homeModules/package-linux.nix flakeContext;
        package-minimum = import ./modules/homeModules/package-minimum.nix flakeContext;
      };
    };
}
