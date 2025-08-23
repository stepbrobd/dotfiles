{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "ysun.life"
    {
      life_ysun_apex = mkPersonalSiteRebind { name = "@"; };
      life_ysun_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "ysun.life"
    "life_ysun"
  ;
}
