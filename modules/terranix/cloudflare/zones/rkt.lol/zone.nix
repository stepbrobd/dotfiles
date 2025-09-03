{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "rkt.lol";
in
{
  resource.cloudflare_zone.lol_rkt = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.lol_rkt_acns_settings = mkZoneSettings zone;
}
