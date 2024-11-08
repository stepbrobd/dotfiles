{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  outputs = { self, ... } @ inputs: inputs.autopilot.lib.mkFlake
    {
      inherit inputs;

      autopilot = {
        lib = {
          path = ./lib;
          extender = inputs.nixpkgs.lib;
          extensions = with inputs; [ autopilot.lib colmena.lib darwin.lib hm.lib parts.lib utils.lib ];
        };

        nixpkgs = {
          config = { allowUnfree = true; };
          overlays = [ self.overlays.default ];
          instances = [{ name = "pkgs"; value = inputs.nixpkgs; }];
        };

        parts.path = ./parts;
      };
    }
    { systems = import inputs.systems; };

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # a
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "darwin";
    agenix.inputs.home-manager.follows = "hm";
    agenix.inputs.systems.follows = "systems";
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
    compat.url = "github:edolstra/flake-compat";
    compat.flake = false;
    crane.url = "github:ipetkov/crane";
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    cosmic.inputs.nixpkgs.follows = "nixpkgs";
    cosmic.inputs.nixpkgs-stable.follows = "nixpkgs";
    cosmic.inputs.rust-overlay.follows = "rust-overlay";
    cosmic.inputs.flake-compat.follows = "compat";
    # d
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # f
    flakey-profile.url = "github:lf-/flakey-profile";
    # g
    gallery.url = "github:sambecker/exif-photo-blog";
    gallery.flake = false;
    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    git-hooks.inputs.flake-compat.follows = "compat";
    git-hooks.inputs.gitignore.follows = "gitignore";
    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";
    # h
    hm.url = "github:nix-community/home-manager";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    # i
    impermanence.url = "github:nix-community/impermanence";
    index.url = "github:nix-community/nix-index-database";
    index.inputs.nixpkgs.follows = "nixpkgs";
    # l
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.crane.follows = "crane";
    lanzaboote.inputs.flake-compat.follows = "compat";
    lanzaboote.inputs.flake-parts.follows = "parts";
    lanzaboote.inputs.flake-utils.follows = "utils";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    lanzaboote.inputs.rust-overlay.follows = "rust-overlay";
    lix.url = "git+https://git@git.lix.systems/lix-project/lix?ref=refs/tags/2.91.1";
    lix.flake = false;
    lix-module.url = "git+https://git.lix.systems/lix-project/nixos-module?ref=refs/tags/2.91.1-1";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.flake-utils.follows = "utils";
    lix-module.inputs.flakey-profile.follows = "flakey-profile";
    lix-module.inputs.lix.follows = "lix";
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
    nixvim.inputs.git-hooks.follows = "git-hooks";
    nixvim.inputs.home-manager.follows = "hm";
    nixvim.inputs.nix-darwin.follows = "darwin";
    nixvim.inputs.nuschtosSearch.follows = "";
    nixvim.inputs.treefmt-nix.follows = "treefmt";
    # p
    parts.url = "github:hercules-ci/flake-parts";
    parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
    pre-commit-hooks.inputs.flake-compat.follows = "compat";
    pre-commit-hooks.inputs.gitignore.follows = "gitignore";
    # r
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # s
    schemas.url = "github:determinatesystems/flake-schemas";
    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";
    # t
    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs";
    # u
    utils.url = "github:numtide/flake-utils";
    utils.inputs.systems.follows = "systems";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
      "https://colmena.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };
}
