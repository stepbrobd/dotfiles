{ lib, ... }:

lib.deepMergeAttrsList (
  with lib.terranix.provider;
  [
    aws
    cloudflare
    fastly
  ]
)
