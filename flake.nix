{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  outputs = { self, ... } @ inputs:
    let inherit (self) outputs; in inputs.parts.lib.mkFlake
      {
        inherit inputs;
        specialArgs = { inherit outputs; };
      }
      {
        debug = true;
        systems = import inputs.systems;
        imports = [ ./parts ];

        flake = let inherit (outputs) lib; in {
          nixosModules = {
            common = import ./modules/common;
            graphical = import ./modules/nixos/graphical.nix;
            minimal = import ./modules/nixos/minimal.nix;
          };

          darwinModules = {
            common = import ./modules/common;
            default = import ./modules/darwin;
          };

          hmModules.ysun = {
            darwin = import ./modules/home/ysun/darwin.nix;
            graphical = import ./modules/home/ysun/graphical.nix;
            linux = import ./modules/home/ysun/linux.nix;
            minimal = import ./modules/home/ysun/minimal.nix;
          };

          # SSDNodes Performance, 8 vCPU, 32GB RAM, 640GB Storage
          nixosConfigurations.nrt-1 = lib.mkSystem rec {
            systemType = "nixos";
            hostPlatform = "x86_64-linux";
            systemStateVersion = "24.05";
            hmStateVersion = systemStateVersion;
            systemConfig = ./systems/nixos/nrt-1;
            username = "ysun";
            extraModules = [
              inputs.srvos.nixosModules.server
              outputs.nixosModules.common
              outputs.nixosModules.minimal
            ];
            extraHMModules = [ outputs.hmModules.ysun.minimal ];
          };

          # EC2 T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
          nixosConfigurations.zrh-1 = lib.mkSystem rec {
            systemType = "nixos";
            hostPlatform = "x86_64-linux";
            systemStateVersion = "24.05";
            hmStateVersion = systemStateVersion;
            systemConfig = ./systems/nixos/zrh-1;
            username = "ysun";
            extraModules = [
              inputs.srvos.nixosModules.server
              outputs.nixosModules.common
              outputs.nixosModules.minimal
            ];
            extraHMModules = [ outputs.hmModules.ysun.minimal ];
          };

          # EC2 T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
          nixosConfigurations.zrh-2 = lib.mkSystem rec {
            systemType = "nixos";
            hostPlatform = "x86_64-linux";
            systemStateVersion = "24.05";
            hmStateVersion = systemStateVersion;
            systemConfig = ./systems/nixos/zrh-2;
            username = "ysun";
            extraModules = [
              inputs.srvos.nixosModules.server
              outputs.nixosModules.common
              outputs.nixosModules.minimal
            ];
            extraHMModules = [ outputs.hmModules.ysun.minimal ];
          };

          # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
          nixosConfigurations.fwl-13 = lib.mkSystem rec {
            systemType = "nixos";
            hostPlatform = "x86_64-linux";
            systemStateVersion = "24.05";
            hmStateVersion = systemStateVersion;
            systemConfig = ./systems/nixos/fwl-13;
            username = "ysun";
            extraModules = [
              inputs.disko.nixosModules.disko
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.nixos-generators.nixosModules.all-formats
              inputs.nixos-hardware.nixosModules.common-hidpi
              inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
              inputs.srvos.nixosModules.desktop
              outputs.nixosModules.common
              outputs.nixosModules.graphical
            ];
            extraHMModules = [ outputs.hmModules.ysun.linux ];
          };

          # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
          darwinConfigurations.mbp-14 = lib.mkSystem {
            systemType = "darwin";
            hostPlatform = "aarch64-darwin";
            systemStateVersion = 4;
            hmStateVersion = "24.05";
            systemConfig = ./systems/darwin/mbp-14;
            username = "ysun";
            extraModules = [ outputs.darwinModules.common outputs.darwinModules.default ];
            extraHMModules = [ outputs.hmModules.ysun.darwin ];
          };

          # MacBook Pro 16-inch, Intel Core i9-9980HK, 32GB RAM, 2TB Storage
          darwinConfigurations.mbp-16 = lib.mkSystem {
            systemType = "darwin";
            hostPlatform = "x86_64-darwin";
            systemStateVersion = 4;
            hmStateVersion = "24.05";
            systemConfig = ./systems/darwin/mbp-16;
            username = "ysun";
            extraModules = [ outputs.darwinModules.common outputs.darwinModules.default ];
            extraHMModules = [ outputs.hmModules.ysun.darwin ];
          };

          hydraJobs =
            let
              configsFor = systemType: lib.mapAttrs (n: v: v.config.system.build.toplevel) outputs."${systemType}Configurations";
            in
            {
              inherit (outputs) packages devShells;
              # nixosConfigurations = configsFor "nixos";
              # darwinConfigurations = configsFor "darwin";
            };
        };
      };

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
    impermanence.url = "github:nix-community/impermanence";
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
