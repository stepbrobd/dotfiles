{ inputs, lib, ... }:

let
  inherit (lib) deepMergeAttrsList filesList importApplyWithArgs kebabToCamel loadAll map;

  # args passed to `importApplyWithArgs`
  moduleArgs = { inherit inputs lib; };
  # not `modulesPath`
  modulePath = ../../modules;

  moduleFor = name: loadAll {
    dir = "${modulePath}/${name}";
    importer = importApplyWithArgs;
    transformer = kebabToCamel;
    excludes = [ ];
    args = moduleArgs;
  };

  # common for `darwinModules` and `nixosModules`
  # DO NOT use this in home-manager
  common = moduleFor "common";
in
deepMergeAttrsList (map
  (x: import x { inherit common moduleFor; })
  (filesList ./. [ "default.nix" ])
)
