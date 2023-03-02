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

    neovim-nightly-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };
  };

  outputs = inputs:
    let
      flakeContext = { inherit inputs; };
    in
    {
      darwinConfigurations = {
        aarch64 = import ./nix/darwinConfigurations/aarch64.nix flakeContext;
      };
      darwinModules = {
        default = import ./nix/darwinModules/default.nix flakeContext;
        overlays = import ./nix/darwinModules/overlays.nix flakeContext;
      };
      homeConfigurations = {
        StepBroBD = import ./nix/homeConfigurations/StepBroBD.nix flakeContext;
      };
      homeModules = {
        activation = import ./nix/homeModules/activation.nix flakeContext;
        default = import ./nix/homeModules/default.nix flakeContext;
        packages = import ./nix/homeModules/packages.nix flakeContext;
      };
    };
}
