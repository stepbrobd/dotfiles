{ lib, inputs, ... }:

let
  inherit (lib) mapAttrs mapAttrs' nameValuePair;

  checksFor = name: checks: mapAttrs'
    (n: v: nameValuePair (name + "." + n) v)
    checks;

  configsFor = os: mapAttrs (_: v: v.config.system.build.toplevel) inputs.self."${os}Configurations";
in
{
  perSystem = { self', ... }: {
    checks = checksFor "packages" self'.packages;
  };

  flake.hydraJobs = {
    inherit (inputs.self) packages;
    nixosConfigurations = configsFor "nixos";
    darwinConfigurations = configsFor "darwin";
  };
}
