{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneDnsSettings;
  zone = "gskr.ing";
in
{
  resource.cloudflare_zone.ing_gskr = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.ing_gskr_acns_settings = mkZoneDnsSettings zone;
}
