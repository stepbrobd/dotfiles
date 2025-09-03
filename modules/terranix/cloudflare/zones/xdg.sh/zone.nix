{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneSettings;
  zone = "xdg.sh";
in
{
  resource.cloudflare_zone.sh_xdg = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.sh_xdg_acns_settings = mkZoneSettings zone;
}
