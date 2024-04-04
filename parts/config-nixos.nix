{ ... } @ args:

let
  inherit (args) inputs outputs;
  inherit (outputs.lib) genAttrs mkSystem;

  stateVersion = "24.05";

  serverConfigFor = host: mkSystem {
    systemType = "nixos";
    hostPlatform = "x86_64-linux";
    systemStateVersion = stateVersion;
    hmStateVersion = stateVersion;
    systemConfig = ../systems/nixos/. + "/${host}";
    username = "ysun";
    extraModules = [
      inputs.srvos.nixosModules.server
      outputs.nixosModules.caddy
      outputs.nixosModules.common
      outputs.nixosModules.minimal
    ];
    extraHMModules = [ outputs.hmModules.ysun.minimal ];
  };
in
{
  flake.nixosConfigurations = {
    # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
    framework = mkSystem {
      systemType = "nixos";
      hostPlatform = "x86_64-linux";
      systemStateVersion = stateVersion;
      hmStateVersion = stateVersion;
      systemConfig = ../systems/nixos/framework;
      username = "ysun";
      extraModules = [
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixos-generators.nixosModules.all-formats
        inputs.nixos-hardware.nixosModules.common-hidpi
        inputs.nixos-hardware.nixosModules.framework-13th-gen-intel
        inputs.srvos.nixosModules.desktop
        outputs.nixosModules.common
        outputs.nixosModules.graphical
      ];
      extraHMModules = [ outputs.hmModules.ysun.linux ];
    };
  } // genAttrs [
    "nrt-1" # SSDNodes Performance, 8 vCPU, 32GB RAM, 640GB Storage
    "zrh-1" # EC2 T3.Large, 2 vCPU, 8GB RAM, 30GB Storage
    "zrh-2" # EC2 T3.Micro, 2 vCPU, 1GB RAM, 30GB Storage
  ]
    (x: serverConfigFor x);
}
