{ common, modulesFor, ... }:

{ flake.nixosModules = common // modulesFor "nixos"; }
