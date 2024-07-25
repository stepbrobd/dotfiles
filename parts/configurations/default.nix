{ lib, inputs, ... }:

let
  stateVersion = "24.11";

  inherit (lib) deepMergeAttrsList filesList map;
in
deepMergeAttrsList (map
  (x: import x { inherit lib inputs stateVersion; })
  (filesList ./. [ "default.nix" ])
)
