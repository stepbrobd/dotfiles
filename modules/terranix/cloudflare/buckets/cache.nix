{ lib, ... }:

{
  resource.cloudflare_r2_bucket.co_ysun_r2_cache = lib.terranix.mkBucket {
    name = "cache";
    jurisdiction = "default";
  };
}
