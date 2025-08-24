{ lib, ... }:

lib.deepMergeAttrsList (
  with lib.terranix.provider;
  [
    sops
    tailscale
  ]
)
