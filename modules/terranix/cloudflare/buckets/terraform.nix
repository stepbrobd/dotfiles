{ lib, ... }:

{
  resource.cloudflare_r2_bucket.co_ysun_r2_terraform = lib.terranix.mkBucket {
    name = "terraform";
    jurisdiction = "eu";
  };
}
