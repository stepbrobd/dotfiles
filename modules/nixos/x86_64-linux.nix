{ inputs, ... }@context:
let
  nixosModule = { config, lib, pkgs, ... }: { };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    nixosModule
    inputs.agenix.nixosModules.default
  ];
  system = "x86_64-linux";
}
