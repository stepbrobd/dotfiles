{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "ysun.life"
    {
      life_ysun_apex = mkPersonalSiteRebind { name = "@"; };
      life_ysun_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "ysun.life"
    "life_ysun"
  ;
}
