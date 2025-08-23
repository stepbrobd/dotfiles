{ lib, ... }:

let
  inherit (lib.terranix) mkZone;# mkZoneSettings;
  zone = "ysun.co";
in
{
  resource.cloudflare_zone.co_ysun = mkZone {
    name = zone;
  };

  # resource.cloudflare_zone_dns_settings.co_ysun_acns_settings = mkZoneSettings zone;
}
