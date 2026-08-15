{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkZoneDnsSettings;
  zone = "churn.cards";
in
{
  resource.cloudflare_zone.cards_churn = mkZone {
    name = zone;
  };

  resource.cloudflare_zone_dns_settings.cards_churn_acns_settings = mkZoneDnsSettings zone;
}
