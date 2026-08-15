{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneDnsSettings;
  zone = "ysun.us";
in
{
  resource.cloudflare_zone.us_ysun = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.us_ysun_acns_settings = mkZoneDnsSettings zone;
}
