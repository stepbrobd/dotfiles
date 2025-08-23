{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "deeznuts.phd"
    {
      phd_deeznuts_apex = mkPersonalSiteRebind { name = "@"; };
      phd_deeznuts_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "deeznuts.phd"
    "phd_deeznuts"
  ;
}
