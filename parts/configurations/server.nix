{ lib, inputs, stateVersion }:

let
  hosts = [
    "lagern" # AWS EC2 ZRH T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
    "bachtel" # AWS EC2 ZRH T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
    "odake" # SSDNodes NRT Performance, 8 vCPU, 32GB RAM, 640GB Storage
    "walberla" # Hetzner Cloud CX32, 4 vCPU, 8GB RAM, 80GB Storage
  ];

  colmena = lib.mkColmena {
    inherit hosts inputs;
    overlays = [ inputs.self.overlays.default ];
    systemType = "nixos";
    hostPlatform = "x86_64-linux";
    systemStateVersion = stateVersion;
    hmStateVersion = stateVersion;
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

  nixosConfigurations = (import (inputs.colmena.outPath + "/src/nix/hive/eval.nix") {
    hermetic = true;
    rawFlake = inputs.self;
    colmenaOptions = import (inputs.colmena.outPath + "/src/nix/hive/options.nix");
    colmenaModules = import (inputs.colmena.outPath + "/src/nix/hive/modules.nix");
  }).nodes;
in
{ flake = { inherit colmena nixosConfigurations; }; }
