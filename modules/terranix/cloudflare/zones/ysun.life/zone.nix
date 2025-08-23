{ lib, ... }:

let
  inherit (lib.terranix) mkZone;# mkZoneSettings;
  zone = "ysun.life";
in
{
  resource.cloudflare_zone.life_ysun = mkZone {
    name = zone;
  };

  # resource.cloudflare_zone_dns_settings.life_ysun_acns_settings = mkZoneSettings zone;
}
