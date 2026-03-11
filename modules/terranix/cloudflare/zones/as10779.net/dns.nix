{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "as10779.net"
    {
      net_as10779_apex = mkPersonalSiteRebind { name = "@"; };
      net_as10779_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "as10779.net"
    "net_as10779"
  ;
}
