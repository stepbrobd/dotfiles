{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "churn.cards"
    {
      cards_churn_apex = mkPersonalSiteRebind { name = "@"; };
      cards_churn_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "churn.cards"
    "cards_churn"
  ;
}
