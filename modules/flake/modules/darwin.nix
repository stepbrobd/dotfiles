{ common, modulesFor, ... }:

{ flake.darwinModules = common // modulesFor "darwin"; }
