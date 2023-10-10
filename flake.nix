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

    disko = {
      url = "github:nix-community/disko";
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

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , flake-schemas
    , nix-index-database
    , disko
    , nixos-hardware
    , lanzaboote
    , nix-darwin
    , home-manager
    , agenix
    , hyprland
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // nix-darwin.lib // home-manager.lib;

      mkSystem = systemType: systemConfig: stateVersion:
        userName:
        extraModules:
        extraHMModules:
        lib."${systemType}System" {
          specialArgs = { inherit inputs outputs; };
          modules = [
            # nix + nixpkgs
            ./modules/nix
            ./modules/nixpkgs
            # system
            systemConfig
            # common modules
            { programs.command-not-found.enable = false; }
            nix-index-database."${systemType}Modules".nix-index
            agenix."${systemType}Modules".age
            # home + home-manager
            (./. + "/users/${userName}")
            home-manager."${systemType}Modules".home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs outputs; };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users."${userName}" = {
                imports = [
                  (./. + "/users/${userName}/home.nix")
                  nix-index-database.hmModules.nix-index
                  agenix.homeManagerModules.age
                ] ++ extraHMModules;
              };
            }
            # state version
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
            # fonts
            ./modules/fonts
            # gnupg
            ./modules/gnupg
            # greeter
            ./modules/greetd
            # desktop environment
            ./modules/hyprland
            # input
            ./modules/i18n
            # silent boot
            ./modules/plymouth
            disko.nixosModules.disko
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.common-hidpi
            nixos-hardware.nixosModules.framework
          ]
          [
            ./users/ysun/modules/alacritty
            ./users/ysun/modules/atuin
            ./users/ysun/modules/bat
            ./users/ysun/modules/direnv
            ./users/ysun/modules/git
            ./users/ysun/modules/gpg
            ./users/ysun/modules/hyprland
            ./users/ysun/modules/lsd
            ./users/ysun/modules/neovim
            ./users/ysun/modules/pyenv
            ./users/ysun/modules/waybar
            ./users/ysun/modules/zsh
          ];

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
    } // flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            agenix.packages.${system}.agenix
            git
            direnv
            nix-direnv
          ];
        };
      });

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://cache.ngi0.nixos.org"
      "https://stepbrobd.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-update.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "stepbrobd.cachix.org-1:Aa5jdkPVrCOvzaLTC0kVP5PYQ5BtNnLg1tG1Qa/QuE4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
    ];
  };
}
