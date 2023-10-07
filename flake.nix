{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-schemas.url = "github:determinatesystems/flake-schemas";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , flake-schemas
    , nix-index-database
    , nixos-hardware
    , lanzaboote
    , nix-darwin
    , home-manager
    , agenix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // nix-darwin.lib // home-manager.lib;

      mkSystem = systemType: systemConfig: stateVersion:
        userName:
        extraModules:
        extraHomeModules:
        lib."${systemType}System" {
          specialArgs = { inherit inputs outputs; };

          modules = [
            systemConfig

            (./. + "/users/${userName}")
            home-manager."${systemType}Modules".home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${userName}" = {
                imports = [
                  (./. + "/users/${userName}/home.nix")
                  nix-index-database.hmModules.nix-index
                ] ++ extraHomeModules;
              };
            }

            { system.stateVersion = stateVersion; }
            { home-manager.users."${userName}".home.stateVersion = stateVersion; }
          ] ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
        fwl-13 = mkSystem "nixos" ./systems/ysun.co/fwl-13 "23.11"
          "ysun"
          [
            nixos-hardware.nixosModules.framework
            lanzaboote.nixosModules.lanzaboote
          ]
          [ ];

        # Vultr VPS, 1 vCPU, 1GB RAM, 25GB Storage
        router-1 = mkSystem "nixos" ./systems/as10779.net/router-1 "23.11"
          "ysun"
          [ ]
          [ ];
      };

      darwinConfigurations = {
        # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
        mbp-14 = mkSystem "darwin" ./systems/ysun.co/mbp-14 "23.11"
          "ysun"
          [ ]
          [ ];

        # MacBook Pro 16-inch, Intel Core i9-9980HK, 32GB RAM, 2TB Storage
        mbp-16 = mkSystem "darwin" ./systems/ysun.co/mbp-16 "23.11"
          "ysun"
          [ ]
          [ ];
      };
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      formatter = pkgs.nixpkgs-fmt;

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          direnv
          nix-direnv
          git
        ];
      };
    });

  nixConfig = {
    extra-substituters = [
      "https://cache.ngi0.nixos.org"
      "https://stepbrobd.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-update.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "stepbrobd.cachix.org-1:Aa5jdkPVrCOvzaLTC0kVP5PYQ5BtNnLg1tG1Qa/QuE4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
    ];
  };
}
