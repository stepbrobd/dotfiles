{
  description = "@stepbrobd: yet another dotfiles repo with nix";

  outputs =
    { self
    , nixpkgs
    , haumea
    , flake-utils
    , flake-schemas
    , nix-darwin
    , home-manager
    , agenix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      rev = self.rev or self.dirtyRev or null;
      lib = nixpkgs.lib // nix-darwin.lib // home-manager.lib // haumea.lib.load {
        src = ./libs;
        inputs = {
          inherit lib rev inputs outputs;
        };
      };

      minimalModules = [
        ./modules/nextdns
        ./modules/tailscale
      ];

      minimalHMModules = [
        ./users/ysun/modules/nixvim
        ./users/ysun/modules/tmux
        ./users/ysun/modules/zsh
      ];

      commonModules = [
        ./modules/activation
        ./modules/fonts
      ];

      commonHMModules = [
        ./users/ysun/modules/alacritty
        ./users/ysun/modules/atuin
        ./users/ysun/modules/bat
        ./users/ysun/modules/btop
        ./users/ysun/modules/direnv
        ./users/ysun/modules/git
        ./users/ysun/modules/gpg
        ./users/ysun/modules/lsd
        ./users/ysun/modules/nushell
        ./users/ysun/modules/pyenv
        ./users/ysun/modules/vscode
        # ./users/ysun/modules/zathura
      ];
    in
    {
      # EC2 T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
      nixosConfigurations.zrh-1 = lib.mkServer {
        systemType = "nixos";
        hostPlatform = "x86_64-linux";
        stateVersion = "24.05";
        systemConfig = ./systems/as10779.net/zrh-1;
        username = "ysun";
        extraModules = minimalModules ++ [
          inputs.nixos-generators.nixosModules.amazon
          inputs.srvos.nixosModules.hardware-amazon
          inputs.srvos.nixosModules.server
        ];
      };

      # EC2 T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
      nixosConfigurations.zrh-2 = lib.mkServer {
        systemType = "nixos";
        hostPlatform = "x86_64-linux";
        stateVersion = "24.05";
        systemConfig = ./systems/as10779.net/zrh-2;
        username = "ysun";
        extraModules = minimalModules ++ [
          inputs.nixos-generators.nixosModules.amazon
          inputs.srvos.nixosModules.hardware-amazon
          inputs.srvos.nixosModules.server
        ];
      };

      # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
      nixosConfigurations.fwl-13 = lib.mkSystem rec {
        systemType = "nixos";
        hostPlatform = "x86_64-linux";
        systemStateVersion = "24.05";
        hmStateVersion = systemStateVersion;
        systemConfig = ./systems/ysun.co/fwl-13;
        username = "ysun";
        extraModules = minimalModules ++ commonModules ++ [
          ./modules/greetd
          ./modules/hyprland
          ./modules/i18n
          ./modules/networking
          ./modules/plymouth
          ./modules/swaylock
          ./modules/wireshark
          inputs.disko.nixosModules.disko
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-generators.nixosModules.all-formats
          inputs.nixos-hardware.nixosModules.common-hidpi
          inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
        ];
        extraHMModules = minimalHMModules ++ commonHMModules ++ [
          ./users/ysun/modules/cursor
          ./users/ysun/modules/dunst
          ./users/ysun/modules/firefox
          ./users/ysun/modules/gtk
          ./users/ysun/modules/hyprland
          ./users/ysun/modules/mpd
          ./users/ysun/modules/rofi
          ./users/ysun/modules/swaylock
          ./users/ysun/modules/waybar
          ./users/ysun/modules/wpaperd
        ];
      };

      # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
      darwinConfigurations.mbp-14 = lib.mkSystem {
        systemType = "darwin";
        hostPlatform = "aarch64-darwin";
        systemStateVersion = 4;
        hmStateVersion = "24.05";
        systemConfig = ./systems/ysun.co/mbp-14;
        username = "ysun";
        extraModules = minimalModules ++ commonModules ++ [ ./modules/homebrew ];
        extraHMModules = minimalHMModules ++ commonHMModules;
      };

      # MacBook Pro 16-inch, Intel Core i9-9980HK, 32GB RAM, 2TB Storage
      darwinConfigurations.mbp-16 = lib.mkSystem {
        systemType = "darwin";
        hostPlatform = "x86_64-darwin";
        systemStateVersion = 4;
        hmStateVersion = "24.05";
        systemConfig = ./systems/ysun.co/mbp-16;
        username = "ysun";
        extraModules = minimalModules ++ commonModules ++ [ ./modules/homebrew ];
        extraHMModules = minimalHMModules ++ commonHMModules;
      };

      # templates
      templates = lib.attrsets.genAttrs
        (builtins.attrNames (builtins.readDir ./templates))
        (path: {
          description = "template for ${path}";
          path = ./templates/${path};
        });
    } // flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; allowUnfreePredicate = (_: true); };
        };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        devShells.default =
          let
            terraform = pkgs.terraform.withPlugins (p: with p; [
              cloudflare
              sops
            ]);
          in
          pkgs.mkShell {
            packages = with pkgs; [
              agenix.packages.${system}.agenix
              direnv
              git
              google-cloud-sdk
              nix-direnv
              terraform
            ];
          };
      });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.home-manager.follows = "home-manager";
    };

    ysun = {
      url = "github:stepbrobd/ysun";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

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
