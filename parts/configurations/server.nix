{ getSystem, inputs, lib, stateVersion }:

let
  inherit (lib) mkColmena;
  hosts = [
    "goffle" # Vultr, 1 vCPU, 1GB RAM, 25GB Storage
    "halti" # Garnix.io Hosting, test server
    "kongo" # Vultr, 1 vCPU, 1GB RAM, 25GB Storage
    "odake" # SSDNodes NRT Performance, 8 vCPU, 32GB RAM, 640GB Storage
    "toompea" # V.PS Pro Tallinn, 4 vCPU, 4GB RAM, 40GB Storage
    "walberla" # Hetzner Cloud CX32, 4 vCPU, 8GB RAM, 80GB Storage
  ];

  colmena = mkColmena rec {
    inherit inputs hosts stateVersion;
    os = "nixos";
    platform = "x86_64-linux";
    users = { ysun = with inputs.self; [ hmModules.ysun.minimal ]; };
    modules = with inputs; [
      self.nixosModules.acme
      self.nixosModules.as10779
      self.nixosModules.attic
      self.nixosModules.caddy
      self.nixosModules.common
      self.nixosModules.desktop
      self.nixosModules.glance
      self.nixosModules.golink
      self.nixosModules.grafana
      self.nixosModules.maxmind
      self.nixosModules.minimal
      self.nixosModules.passwordless
      self.nixosModules.plausible
      self.nixosModules.prometheus
      self.nixosModules.rebuild
      self.nixosModules.server
      self.nixosModules.uptime
      srvos.nixosModules.server
    ];
    nixpkgs = (getSystem platform).allModuleArgs.pkgs;
    specialArgs = { inherit inputs lib; };
  };

  # blocked on colmena #161
  nixosConfigurations = (import "${inputs.colmena}/src/nix/hive/eval.nix" {
    rawFlake = inputs.self;
  }).nodes;
in
{ flake = { inherit colmena nixosConfigurations; }; }
