{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "as18932.net";
in
{
  resource.cloudflare_zone.net_as18932 = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.net_as18932_acns_settings = mkZoneSettings zone;
}
