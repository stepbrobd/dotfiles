{ lib, inputs, stateVersion }:

let
  inherit (lib) genAttrs mkSystem;
in
{
  flake.darwinConfigurations = {
    # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
    macbook = mkSystem {
      inherit inputs;
      systemType = "darwin";
      hostPlatform = "aarch64-darwin";
      systemStateVersion = 4;
      hmStateVersion = stateVersion;
      systemConfig = ../../hosts/laptop/macbook;
      username = "ysun";
      extraModules = with inputs.self; [ darwinModules.common darwinModules.default ];
      extraHMModules = with inputs.self; [ hmModules.ysun.darwin ];
    };
  };

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
  };
}
