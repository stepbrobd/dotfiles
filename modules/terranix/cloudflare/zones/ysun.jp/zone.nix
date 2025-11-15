{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "ysun.jp";
in
{
  resource.cloudflare_zone.jp_ysun = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.jp_ysun_acns_settings = mkZoneSettings zone;
}
