{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "grenug.fr";
in
{
  resource.cloudflare_zone.fr_grenug = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.fr_grenug_acns_settings = mkZoneSettings zone;
}
