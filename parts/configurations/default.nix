{ inputs, lib, getSystem, ... }:

let
  stateVersion = "25.05";

  inherit (lib) deepMergeAttrsList filesList map;
in
deepMergeAttrsList (map
  (x: import x { inherit getSystem inputs lib stateVersion; })
  (filesList ./. [ "default.nix" ])
)
