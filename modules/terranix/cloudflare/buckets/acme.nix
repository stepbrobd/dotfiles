{ lib, ... }:

{
  resource.cloudflare_r2_bucket.co_ysun_r2_acme = lib.terranix.mkBucket {
    name = "acme";
    jurisdiction = "eu";
  };
}
