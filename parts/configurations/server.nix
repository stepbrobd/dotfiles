{ lib, inputs, stateVersion }:

let
  inherit (lib) genAttrs mapAttrs mkSystem;

  serverConfigFor = host: mkSystem {
    inherit inputs;
    systemType = "nixos";
    hostPlatform = "x86_64-linux";
    systemStateVersion = stateVersion;
    hmStateVersion = stateVersion;
    systemConfig = ../../hosts/server/. + "/${host}";
    username = "ysun";
    extraModules = with inputs; [
      srvos.nixosModules.server
      self.nixosModules.caddy
      self.nixosModules.common
      self.nixosModules.desktop
      self.nixosModules.minimal
    ];
    extraHMModules = [
      # outputs.hmModules.ysun.minimal
    ];
  };

  nixosConfigurations = genAttrs [
    "lagern" # AWS EC2 ZRH T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
    "bachtel" # AWS EC2 ZRH T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
    "odake" # SSDNodes NRT Performance, 8 vCPU, 32GB RAM, 640GB Storage
    "walberla" # Hetzner Cloud CX32, 4 vCPU, 8GB RAM, 80GB Storage
  ]
    (x: serverConfigFor x);

  # colmena #161
  mkColmenaFromNixOSConfigurations = conf: {
    meta = {
      nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };

      nodeNixpkgs = mapAttrs (_: value: value.pkgs) conf;

      nodeSpecialArgs = mapAttrs (_: value: value._module.specialArgs) conf;
    };
  } // mapAttrs (_: value: { imports = value._module.args.modules; }) conf;

  colmena = mkColmenaFromNixOSConfigurations nixosConfigurations;
in
{ flake = { inherit colmena nixosConfigurations; }; }
