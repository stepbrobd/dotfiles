{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    flake-schemas.url = "github:determinatesystems/flake-schemas";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    srvos = {
      url = "github:numtide/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    , nixos-generators
    , flake-utils
    , flake-schemas
    , nix-index-database
    , disko
    , nixos-hardware
    , srvos
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

      mkSystem = systemType: hostPlatform: stateVersion:
        systemConfig:
        userName:
        extraModules:
        extraHMModules: {
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
                  { xdg = { enable = true; userDirs = { enable = true; createDirectories = true; }; }; }
                  (./. + "/users/${userName}/home.nix")
                  nix-index-database.hmModules.nix-index
                  agenix.homeManagerModules.age
                ] ++ extraHMModules;
              };
            }
            # platform
            { nixpkgs.hostPlatform = lib.mkDefault hostPlatform; }
            # state version
            { system.stateVersion = stateVersion; }
            { home-manager.users."${userName}".home.stateVersion = stateVersion; }
          ] ++ extraModules;
        };

      # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
      fwl-13 = mkSystem "nixos" "x86_64-linux" "23.11"
        ./systems/ysun.co/fwl-13
        "ysun"
        [
          ./modules/activation
          ./modules/fonts
          ./modules/greetd
          ./modules/hyprland
          ./modules/i18n
          ./modules/networking
          ./modules/nextdns
          ./modules/plymouth
          ./modules/swaylock
          ./modules/tailscale
          nixos-generators.nixosModules.all-formats
          disko.nixosModules.disko
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.common-hidpi
          nixos-hardware.nixosModules.framework
          nixos-hardware.nixosModules.framework-13th-gen-intel
        ]
        [
          ./users/ysun/modules/alacritty
          ./users/ysun/modules/atuin
          ./users/ysun/modules/bat
          ./users/ysun/modules/btop
          ./users/ysun/modules/chromium
          ./users/ysun/modules/cursor
          ./users/ysun/modules/direnv
          ./users/ysun/modules/dunst
          ./users/ysun/modules/git
          ./users/ysun/modules/gpg
          ./users/ysun/modules/gtk
          ./users/ysun/modules/hyprland
          ./users/ysun/modules/lsd
          ./users/ysun/modules/mpd
          ./users/ysun/modules/neovim
          ./users/ysun/modules/nushell
          ./users/ysun/modules/pyenv
          ./users/ysun/modules/rofi
          ./users/ysun/modules/swaylock
          ./users/ysun/modules/tmux
          ./users/ysun/modules/vscode
          ./users/ysun/modules/waybar
          ./users/ysun/modules/wpaperd
          ./users/ysun/modules/zathura
          ./users/ysun/modules/zsh
        ];

      # GCE
      vault = mkSystem "nixos" "x86_64-linux" "23.11"
        ./systems/ysun.co/vault
        "ysun"
        [
          ./modules/nextdns
          ./modules/tailscale
          nixos-generators.nixosModules.all-formats
          srvos.nixosModules.server
        ]
        [
          ./users/ysun/modules/neovim
          ./users/ysun/modules/tmux
          ./users/ysun/modules/zsh
        ];

      # Vultr VPS, 1 vCPU, 1GB RAM, 25GB Storage
      router = mkSystem "nixos" "x86_64-linux" "23.11"
        ./systems/as10779.net/router
        "ysun"
        [
          ./modules/nextdns
          ./modules/tailscale
          nixos-generators.nixosModules.all-formats
          srvos.nixosModules.server
        ]
        [
          ./users/ysun/modules/neovim
          ./users/ysun/modules/tmux
          ./users/ysun/modules/zsh
        ];

      # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
      mbp-14 = mkSystem "darwin" "aarch64-darwin" "23.11"
        ./systems/ysun.co/mbp-14
        "ysun"
        [
          ./modules/fonts
          ./modules/nextdns
          ./modules/tailscale
        ]
        [
          ./users/ysun/modules/alacritty
          ./users/ysun/modules/atuin
          ./users/ysun/modules/bat
          ./users/ysun/modules/btop
          ./users/ysun/modules/direnv
          ./users/ysun/modules/git
          ./users/ysun/modules/gpg
          ./users/ysun/modules/lsd
          ./users/ysun/modules/neovim
          ./users/ysun/modules/nushell
          ./users/ysun/modules/pyenv
          ./users/ysun/modules/tmux
          ./users/ysun/modules/vscode
          ./users/ysun/modules/zathura
          ./users/ysun/modules/zsh
        ];

      # MacBook Pro 16-inch, Intel Core i9-9980HK, 32GB RAM, 2TB Storage
      mbp-16 = mkSystem "darwin" "x86_64-darwin" "23.11"
        ./systems/ysun.co/mbp-16
        "ysun"
        [
          ./modules/fonts
          ./modules/nextdns
          ./modules/tailscale
        ]
        [
          ./users/ysun/modules/alacritty
          ./users/ysun/modules/atuin
          ./users/ysun/modules/bat
          ./users/ysun/modules/btop
          ./users/ysun/modules/direnv
          ./users/ysun/modules/git
          ./users/ysun/modules/gpg
          ./users/ysun/modules/lsd
          ./users/ysun/modules/neovim
          ./users/ysun/modules/nushell
          ./users/ysun/modules/pyenv
          ./users/ysun/modules/tmux
          ./users/ysun/modules/vscode
          ./users/ysun/modules/zathura
          ./users/ysun/modules/zsh
        ];
    in
    {
      # servers
      nixosConfigurations.vault = lib.nixosSystem vault;
      nixosConfigurations.router = lib.nixosSystem router;

      # workstations + laptops
      nixosConfigurations.fwl-13 = lib.nixosSystem fwl-13;
      darwinConfigurations.mbp-14 = lib.darwinSystem mbp-14;
      darwinConfigurations.mbp-16 = lib.darwinSystem mbp-16;
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
