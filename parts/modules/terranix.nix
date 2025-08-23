{ config, lib, modulesFor, ... }:

{
  flake.terranixModules = modulesFor "terranix";

  perSystem = { system, ... }: {
    packages.terranixConfiguration =
      let
        inherit system;
        modules = lib.attrValues config.flake.terranixModules;
      in
      (lib.terranixConfiguration {
        inherit system modules;
      }).overrideAttrs (_: {
        passthru = {
          inherit (lib.terranixConfigurationAst {
            inherit system modules;
          }) config;
        };
      });
  };
}
