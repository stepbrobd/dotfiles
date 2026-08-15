{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneDnsSettings;
  zone = "104.161.23.in-addr.arpa";
in
{
  resource.cloudflare_zone.arpa_in_addr_23_161_104 = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.arpa_in_addr_23_161_104_acns_settings = mkZoneDnsSettings zone;
}
