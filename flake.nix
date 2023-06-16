{
  description = "@StepBroBD: Yet another dotfiles repo with Nix";

  inputs = {
    master.url = "flake:nixpkgs/master";
    unstable.url = "flake:nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "flake:nixpkgs/nixos-23.05";
    darwin-stable.url = "flake:nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs.follows = "master";

    utils.url = "flake:flake-utils";

    darwin = {
      url = "flake:nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "flake:home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comma-overlay = {
      url = "github:nix-community/comma";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    osu-overlay = {
      url = "github:stepbrobd/osu-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    raycast-overlay = {
      url = "github:stepbrobd/raycast-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    vscode-overlay = {
      url = "github:stepbrobd/vscode-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , ...
    } @ inputs:
    let
      context = {
        inherit inputs;
      };

      eachSystem = utils.lib.eachSystem [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      homeConfigurations = {
        StepBroBD = import ./modules/home/StepBroBD.nix context;
      };

      nixosConfigurations = {
        aarch64-linux = import ./modules/nixos/aarch64-linux.nix context;
        x86_64-linux = import ./modules/nixos/x86_64-linux.nix context;
      };

      darwinConfigurations = {
        aarch64-darwin = import ./modules/darwin/aarch64-darwin.nix context;
        x86_64-darwin = import ./modules/darwin/x86_64-darwin.nix context;
      };
    };
}
