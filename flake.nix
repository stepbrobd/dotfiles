{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  outputs = { self, ... } @ inputs:
    let
      inherit (self) outputs;
      rev = self.rev or self.dirtyRev or null;
      lib = inputs.nixpkgs.lib // inputs.darwin.lib // inputs.hm.lib // inputs.haumea.lib.load {
        src = ./libs;
        inputs = { inherit lib rev inputs outputs; };
      };
    in
    {
      schemas = inputs.schemas.schemas;

      overlays.default = import ./overlays { inherit lib; };

      templates = lib.mkDynamicAttrs {
        dir = ./templates;
        fun = path: {
          description = "template for ${path}";
          path = ./templates/. + "/${path}";
        };
      };

      hydraJobs =
        let
          configsFor = systemType: lib.mapAttrs (n: v: v.config.system.build.toplevel) self."${systemType}Configurations";
        in
        {
          inherit (self) packages devShells;
          # nixosConfigurations = configsFor "nixos";
          # darwinConfigurations = configsFor "darwin";
        };
    }
    // inputs.utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };
      in
      {
        packages = lib.mkDynamicAttrs {
          dir = ./packages;
          fun = name: pkgs.callPackage (./packages/. + "/${name}") { };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            inputs.agenix.packages.${system}.agenix
            direnv
            git
            nixVersions.unstable
            nix-direnv
          ];
        };

        formatter = pkgs.nixpkgs-fmt;
      }
    );

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # a
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "darwin";
    agenix.inputs.home-manager.follows = "hm";
    agenix.inputs.systems.follows = "systems";
    # c
    compat.url = "github:edolstra/flake-compat";
    compat.flake = false;
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    # d
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "utils";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # g
    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";
    # h
    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    # i
    index.url = "github:nix-community/nix-index-database";
    index.inputs.nixpkgs.follows = "nixpkgs";
    # l
    lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.crane.follows = "crane";
    lanzaboote.inputs.flake-compat.follows = "compat";
    lanzaboote.inputs.flake-parts.follows = "parts";
    lanzaboote.inputs.flake-utils.follows = "utils";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    lanzaboote.inputs.rust-overlay.follows = "rust-overlay";
    # n
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixlib.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.devshell.follows = "devshell";
    nixvim.inputs.flake-compat.follows = "compat";
    nixvim.inputs.flake-parts.follows = "parts";
    nixvim.inputs.home-manager.follows = "hm";
    nixvim.inputs.nix-darwin.follows = "darwin";
    nixvim.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    # p
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-compat.follows = "compat";
    pre-commit-hooks.inputs.flake-utils.follows = "utils";
    pre-commit-hooks.inputs.gitignore.follows = "gitignore";
    # r
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.flake-utils.follows = "utils";
    # s
    schemas.url = "github:determinatesystems/flake-schemas";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    # u
    utils.url = "github:numtide/flake-utils";
    utils.inputs.systems.follows = "systems";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.ngi0.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
