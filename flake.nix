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
              rust-overlay.overlays.default
              unstraightened.overlays.default
            ];
            instances = {
              pkgs = inputs.nixpkgs;
            };
          };

          parts.path = ./parts;
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
    nixpkgs-staging-next.url = "github:nixos/nixpkgs/staging-next";
    # a
    autopilot.url = "github:stepbrobd/autopilot";
    autopilot.inputs.nixpkgs.follows = "nixpkgs";
    autopilot.inputs.parts.follows = "parts";
    autopilot.inputs.systems.follows = "systems";
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
    cornflake.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
    # d
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko?ref=pull/1069/merge";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # f
    flakey-profile.url = "github:lf-/flakey-profile";
    # g
    garnix.url = "github:garnix-io/garnix-lib";
    garnix.inputs.nixpkgs.follows = "nixpkgs";
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
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    # i
    impermanence.url = "github:nix-community/impermanence";
    index.url = "github:nix-community/nix-index-database";
    index.inputs.nixpkgs.follows = "nixpkgs";
    # l
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.crane.follows = "crane";
    lanzaboote.inputs.flake-compat.follows = "compat";
    lanzaboote.inputs.flake-parts.follows = "parts";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "";
    lanzaboote.inputs.rust-overlay.follows = "rust-overlay";
    # n
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixlib.follows = "nixpkgs";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-parts.follows = "parts";
    nixvim.inputs.systems.follows = "systems";
    nixvim.inputs.nuschtosSearch.follows = "";
    # p
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    # r
    rpi.url = "github:nvmd/nixos-raspberrypi";
    rpi.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # s
    schemas.url = "github:determinatesystems/flake-schemas";
    sops.url = "github:mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
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
    # u
    unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    unstraightened.inputs.nixpkgs.follows = "nixpkgs";
    unstraightened.inputs.systems.follows = "systems";
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
