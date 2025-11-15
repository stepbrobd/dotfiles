{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "ysun.jp"
    {
      jp_ysun_apex = mkPersonalSiteRebind { name = "@"; };
      jp_ysun_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "ysun.jp"
    "jp_ysun"
  ;
}
