{ lib, inputs, stateVersion }:

let
  inherit (lib) genAttrs mkSystem;
in
{
  flake.darwinConfigurations = {
    # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
    macbook = mkSystem {
      inherit inputs stateVersion;
      os = "darwin";
      platform = "aarch64-darwin";
      entrypoint = ../../hosts/laptop/macbook;
      users = { ysun = with inputs.self; [ hmModules.ysun.darwin ]; };
      modules = with inputs.self.darwinModules; [
        common
        lix
        nixbuild
        fonts
        homebrew
        sshd
        system
        tailscale
      ];
    };
  };

  flake.nixosConfigurations = {
    # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
    framework = mkSystem {
      inherit inputs stateVersion;
      os = "nixos";
      platform = "x86_64-linux";
      entrypoint = ../../hosts/laptop/framework;
      users = { ysun = with inputs.self; [ hmModules.ysun.linux ]; };
      modules = with inputs; [
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote
        nixos-generators.nixosModules.all-formats
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.framework-13th-gen-intel
        srvos.nixosModules.desktop
        self.nixosModules.common
        self.nixosModules.docker
        self.nixosModules.graphical
        self.nixosModules.lix
      ];
    };
  };
}
