{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/master";
    utils.url = "github:numtide/flake-utils";
    schemas.url = "github:determinatesystems/flake-schemas";

    darwin = {
      url = "flake:nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "flake:home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
    };

    osu-lazer-bin = {
      url = "github:stepbrobd/osu-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    raycast = {
      url = "github:stepbrobd/raycast-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };

    vscode = {
      url = "github:stepbrobd/vscode-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , schemas
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
    } // eachSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      lib = pkgs.lib;
      stdenv = if pkgs.stdenv.isLinux then pkgs.stdenv else pkgs.clangStdenv;
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          direnv
          nix-direnv
        ];
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}
