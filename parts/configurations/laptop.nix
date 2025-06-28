{ getSystem, inputs, lib }:

let
  inherit (lib) mkSystem;

  genSpecialArgs = system: {
    inherit inputs lib;
    inherit ((getSystem system).allModuleArgs) pkgs;
  };
in
{
  flake.darwinConfigurations = {
    # MacBook Pro 14-inch, Apple M2 Max, 64GB RAM, 1TB Storage
    macbook = mkSystem rec {
      inherit inputs;
      os = "darwin";
      platform = "aarch64-darwin";
      entrypoint = ../../hosts/laptop/macbook;
      specialArgs = genSpecialArgs platform;
      users = { ysun = with inputs.self; [ hmModules.ysun.darwin ]; };
      modules = with inputs.self.darwinModules; [
        common
        fonts
        # hammerspoon
        homebrew
        linux-builder
        nixbuild
        ntpd-rs
        passwordless
        sshd
        system
        tailscale
        inputs.srvos.darwinModules.desktop
      ];
    };
  };

  flake.nixosConfigurations = {
    # Framework Laptop 13, Intel Core i7-1360P, 64GB RAM, 1TB Storage
    framework = mkSystem rec {
      inherit inputs;
      os = "nixos";
      platform = "x86_64-linux";
      entrypoint = ../../hosts/laptop/framework;
      specialArgs = genSpecialArgs platform;
      users = { ysun = with inputs.self; [ hmModules.ysun.linux ]; };
      modules = with inputs; [
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote
        nixos-generators.nixosModules.all-formats
        nixos-hardware.nixosModules.common-hidpi
        nixos-hardware.nixosModules.framework-13th-gen-intel
        self.nixosModules.common
        self.nixosModules.cross
        self.nixosModules.docker
        self.nixosModules.graphical
        self.nixosModules.nftables
        self.nixosModules.passwordless
        self.nixosModules.rebuild
        self.nixosModules.tailscale
        self.nixosModules.time
        srvos.nixosModules.desktop
      ];
    };
  };
}
