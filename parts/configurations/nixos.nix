{ lib, inputs, ... }:

let
  inherit (lib) genAttrs mkSystem;

  stateVersion = "24.11";

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
in
{
  flake.nixosConfigurations = {
    # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
    framework = mkSystem {
      inherit inputs;
      systemType = "nixos";
      hostPlatform = "x86_64-linux";
      systemStateVersion = stateVersion;
      hmStateVersion = stateVersion;
      systemConfig = ../../hosts/laptop/framework;
      username = "ysun";
      extraModules = with inputs; [
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote
        nixos-generators.nixosModules.all-formats
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.framework-13th-gen-intel
        srvos.nixosModules.desktop
        self.nixosModules.common
        self.nixosModules.docker
        self.nixosModules.graphical
      ];
      extraHMModules = [ inputs.self.hmModules.ysun.linux ];
    };
  } // genAttrs [
    "odake" # SSDNodes NRT Performance, 8 vCPU, 32GB RAM, 640GB Storage
    "lagern" # AWS EC2 ZRH T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
    "bachtel" # AWS EC2 ZRH T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
    "walberla" # Hetzner Cloud CX32, 4 vCPU, 8GB RAM, 80GB Storage
  ]
    (x: serverConfigFor x);
}
