{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.life_ysun = mkZone {
    name = "ysun.life";
  };
}
