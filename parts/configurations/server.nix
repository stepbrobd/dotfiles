{ getSystem, inputs, lib, stateVersion }:

let
  inherit (lib) mkColmena;
  hosts = [
    "lagern" # AWS EC2 ZRH T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
    "bachtel" # AWS EC2 ZRH T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
    "odake" # SSDNodes NRT Performance, 8 vCPU, 32GB RAM, 640GB Storage
    "walberla" # Hetzner Cloud CX32, 4 vCPU, 8GB RAM, 80GB Storage
  ];

  colmena = mkColmena rec {
    inherit inputs hosts stateVersion;
    os = "nixos";
    platform = "x86_64-linux";
    users = { ysun = with inputs.self; [ hmModules.ysun.minimal ]; };
    modules = with inputs; [
      self.nixosModules.acme
      self.nixosModules.attic
      self.nixosModules.caddy
      self.nixosModules.common
      self.nixosModules.desktop
      self.nixosModules.glance
      self.nixosModules.golink
      self.nixosModules.lix
      self.nixosModules.minimal
      self.nixosModules.passwordless
      self.nixosModules.plausible
      self.nixosModules.server
      self.nixosModules.uptime
      srvos.nixosModules.server
    ];
    nixpkgs = (getSystem platform).allModuleArgs.pkgs;
    specialArgs = { inherit inputs lib; };
  };

  # blocked on colmena #161
  nixosConfigurations = (import ("${inputs.colmena}/src/nix/hive/eval.nix") {
    rawFlake = inputs.self;
  }).nodes;
in
{ flake = { inherit colmena nixosConfigurations; }; }
