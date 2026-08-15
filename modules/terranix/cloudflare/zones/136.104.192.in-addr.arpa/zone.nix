{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneDnsSettings;
  zone = "136.104.192.in-addr.arpa";
in
{
  resource.cloudflare_zone.arpa_in_addr_192_104_136 = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.arpa_in_addr_192_104_136_acns_settings = mkZoneDnsSettings zone;
}
