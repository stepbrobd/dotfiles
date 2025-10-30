{ inputs, lib, getSystem, ... }:

let
  inherit (lib) deepMergeAttrsList filesList map;
in
deepMergeAttrsList (map
  (x: import x { inherit getSystem inputs lib; })
  (filesList ./. [ "default.nix" ])
)
