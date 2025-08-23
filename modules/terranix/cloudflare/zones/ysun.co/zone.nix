{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.co_ysun = mkZone {
    name = "ysun.co";
  };
}
