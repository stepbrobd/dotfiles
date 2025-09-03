{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "stepbrobd.com";
in
{
  resource.cloudflare_zone.com_stepbrobd = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.com_stepbrobd_acns_settings = mkZoneSettings zone;
}
