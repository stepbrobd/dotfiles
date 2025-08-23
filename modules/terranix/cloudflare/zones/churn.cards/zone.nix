{ lib, ... }:

let
  inherit (lib.terranix) mkZone;# mkZoneSettings;
  zone = "churn.cards";
in
{
  resource.cloudflare_zone.cards_churn = mkZone {
    name = zone;
  };

  # resource.cloudflare_zone_dns_settings.cards_churn_acns_settings = mkZoneSettings zone;
}
