{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "as10779.net";
in
{
  resource.cloudflare_zone.net_as10779 = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.net_as10779_acns_settings = mkZoneSettings zone;
}
