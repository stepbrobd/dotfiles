{ inputs, ... }@context:
let
  nixosModule = { config, lib, pkgs, ... }: { };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    nixosModule
  ];
  system = "x86_64-linux";
}
