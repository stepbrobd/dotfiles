{ inputs, lib, ... } @ args:

let
  inherit (lib) deepMergeAttrsList filesList importApplyWithArgs loadAll map;

  # args passed to `importApplyWithArgs`
  moduleArgs = { inherit inputs lib; };
  # not `modulesPath`
  modulePath = ../../modules;

  modulesFor = name: loadAll {
    dir = "${modulePath}/${name}";
    importer = importApplyWithArgs;
    transformer = x: x;
    excludes = [ ];
    args = moduleArgs;
  };

  # common for `darwinModules` and `nixosModules`
  # DO NOT use this in home-manager
  common = modulesFor "common";
in
deepMergeAttrsList (map
  (x: import x (args // { inherit common modulesFor; }))
  (filesList ./. [ "default.nix" ])
)
