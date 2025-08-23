{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "rkt.lol"
    {
      lol_rkt_apex = mkPersonalSiteRebind { name = "@"; };
      lol_rkt_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "rkt.lol"
    "lol_rkt"
  ;
}
