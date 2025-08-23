{ lib, ... }:

let
  inherit (lib.terranix) mkZone;# mkZoneSettings;
  zone = "deeznuts.phd";
in
{
  resource.cloudflare_zone.phd_deeznuts = mkZone {
    name = zone;
  };

  # resource.cloudflare_zone_dns_settings.phd_deeznuts_acns_settings = mkZoneSettings zone;
}
