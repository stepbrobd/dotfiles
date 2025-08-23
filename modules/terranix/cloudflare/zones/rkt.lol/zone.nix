{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.lol_rkt = mkZone {
    name = "rkt.lol";
  };
}
