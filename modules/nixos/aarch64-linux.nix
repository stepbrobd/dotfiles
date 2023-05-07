{ inputs, ... }@context:
let
  nixosModule = { config, lib, pkgs, ... }: { };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    nixosModule
  ];
  system = "aarch64-linux";
}
