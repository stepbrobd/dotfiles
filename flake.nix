{
  description = "@StepBroBD: Yet another dotfiles repo with Nix";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";

    darwin = {
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
      context = {
        inherit inputs;
      };
    in
    {
      darwinConfigurations = {
        aarch64-darwin = import ./modules/darwin/aarch64-darwin.nix context;
        x86_64-darwin = import ./modules/darwin/x86_64-darwin.nix context;
      };
      darwinModules = {
        default = import ./modules/darwinModules/default.nix context;
        overlay = import ./modules/darwinModules/overlay.nix context;
      };
      homeConfigurations = {
        StepBroBD = import ./modules/home/StepBroBD.nix context;
      };
      homeModules = {
        activation = import ./modules/homeModules/activation.nix context;
        default = import ./modules/homeModules/default.nix context;
        package-darwin = import ./modules/homeModules/package-darwin.nix context;
        package-linux = import ./modules/homeModules/package-linux.nix context;
        package-minimum = import ./modules/homeModules/package-minimum.nix context;
      };
    };
}
