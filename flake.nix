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
      homeConfigurations = {
        StepBroBD = import ./modules/home/StepBroBD.nix context;
      };
      darwinConfigurations = {
        aarch64-darwin = import ./modules/darwin/aarch64-darwin.nix context;
        x86_64-darwin = import ./modules/darwin/x86_64-darwin.nix context;
      };

      darwinModules = {
        default = import ./modules/darwin/modules/default.nix context;
        overlay = import ./modules/darwin/modules/overlay.nix context;
      };
      homeModules = {
        default = import ./modules/home/modules/default.nix context;
        pkgs = import ./modules/home/modules/pkgs.nix context;
        activation = import ./modules/home/modules/activation.nix context;
      };
    };
}
