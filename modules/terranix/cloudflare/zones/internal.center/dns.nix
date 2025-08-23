{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "internal.center"
    {
      center_internal_apex = mkPersonalSiteRebind { name = "@"; };
      center_internal_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "internal.center"
    "center_internal"
  ;
}
