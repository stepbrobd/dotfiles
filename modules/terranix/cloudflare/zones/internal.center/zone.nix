{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneDnsSettings;
  zone = "internal.center";
in
{
  resource.cloudflare_zone.center_internal = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.center_internal_acns_settings = mkZoneDnsSettings zone;
}
