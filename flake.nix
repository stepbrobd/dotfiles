{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  outputs =
    { self, ... }@inputs:
    inputs.autopilot.lib.mkFlake
      {
        inherit inputs;

        autopilot = {
          lib = {
            path = ./lib;
            extender = inputs.nixpkgs.lib;
            excludes = [ "secrets.yaml" ];
            extensions = with inputs; [
              autopilot.lib
              colmena.lib
              darwin.lib
              hm.lib
              parts.lib
              terranix.lib
              utils.lib
              { std = inputs.std.lib; }
            ];
          };

          nixpkgs = {
            config = {
              allowUnfree = true;
            };
            overlays = with inputs; [
              self.overlays.default
              golink.overlays.default
              mac-style-plymouth.overlays.default
              rust-overlay.overlays.default
            ];
            instances = {
              pkgs = inputs.nixpkgs;
            };
          };

          parts.path = ./modules/flake;
        };
      }
      {
        debug = true;
        systems = import inputs.systems;
      };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/master";
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # a
    autopilot.url = "github:stepbrobd/autopilot";
    autopilot.inputs.nixpkgs.follows = "nixpkgs";
    autopilot.inputs.parts.follows = "parts";
    autopilot.inputs.systems.follows = "systems";
    # b
    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";
    blueprint.inputs.systems.follows = "systems";
    # c
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    colmena.inputs.stable.follows = "nixpkgs";
    colmena.inputs.flake-compat.follows = "compat";
    colmena.inputs.flake-utils.follows = "utils";
    colmena.inputs.nix-github-actions.follows = "";
    compat.url = "github:edolstra/flake-compat";
    compat.flake = false;
    cornflake.url = "github:jzbor/cornflakes";
    crane.url = "github:ipetkov/crane";
    # d
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # f
    flatpak.url = "github:gmodena/nix-flatpak";
    # g
    garnix.url = "github:garnix-io/garnix-lib";
    garnix.inputs.nixpkgs.follows = "nixpkgs";
    generators.url = "github:nix-community/nixos-generators";
    generators.inputs.nixpkgs.follows = "nixpkgs";
    generators.inputs.nixlib.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "compat";
    git-hooks.inputs.gitignore.follows = "gitignore";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";
    golink.url = "github:tailscale/golink";
    golink.inputs.nixpkgs.follows = "nixpkgs";
    golink.inputs.systems.follows = "systems";
    gomod2nix.url = "github:nix-community/gomod2nix";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";
    gomod2nix.inputs.flake-utils.follows = "utils";
    # h
    hardware.url = "github:nixos/nixos-hardware";
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    # hydra.url = "github:ners/hydra/oidc";
    # hydra.inputs.nixpkgs.follows = "nixpkgs";
    # i
    index.url = "github:nix-community/nix-index-database";
    index.inputs.nixpkgs.follows = "nixpkgs";
    # l
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.crane.follows = "crane";
    lanzaboote.inputs.rust-overlay.follows = "rust-overlay";
    lanzaboote.inputs.pre-commit.follows = "";
    # m
    mac-style-plymouth.url = "github:sergioribera/s4rchiso-plymouth-theme";
    mac-style-plymouth.inputs.nixpkgs.follows = "nixpkgs";
    mac-style-plymouth.inputs.flake-utils.follows = "utils";
    miroir.url = "github:stepbrobd/miroir";
    miroir.inputs.nixpkgs.follows = "nixpkgs";
    miroir.inputs.parts.follows = "parts";
    miroir.inputs.systems.follows = "systems";
    # n
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "parts";
    nixvim.inputs.systems.follows = "systems";
    # p
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    # r
    rpi.url = "github:nvmd/nixos-raspberrypi";
    rpi.inputs.nixpkgs.follows = "nixpkgs";
    rpi.inputs.flake-compat.follows = "compat";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # s
    schemas.url = "github:determinatesystems/flake-schemas";
    sops.url = "github:mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos/pull/765/merge";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    std.url = "github:chessai/nix-std";
    sweep.url = "github:jzbor/nix-sweep";
    sweep.inputs.nixpkgs.follows = "nixpkgs";
    sweep.inputs.cf.follows = "cornflake";
    sweep.inputs.crane.follows = "crane";
    systems.url = "github:nix-systems/default";
    # t
    # tangled.url = "git+https://tangled.sh/@tangled.sh/core";
    # tangled.inputs.nixpkgs.follows = "nixpkgs";
    # tangled.inputs.gitignore.follows = "gitignore";
    # tangled.inputs.gomod2nix.follows = "gomod2nix";
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.flake-parts.follows = "parts";
    terranix.inputs.systems.follows = "systems";
    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
    tsnsrv.url = "github:boinkor-net/tsnsrv";
    tsnsrv.inputs.nixpkgs.follows = "nixpkgs";
    tsnsrv.inputs.flake-parts.follows = "parts";
    # u
    utils.url = "github:numtide/flake-utils";
    utils.inputs.systems.follows = "systems";
    # y
    ysun.url = "github:stepbrobd/ysun";
    ysun.inputs.nixpkgs.follows = "nixpkgs";
    ysun.inputs.parts.follows = "parts";
    ysun.inputs.systems.follows = "systems";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://colmena.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };
}
