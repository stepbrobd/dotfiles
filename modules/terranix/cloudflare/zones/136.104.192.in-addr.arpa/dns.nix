{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "136.104.192.in-addr.arpa"
    {
      arpa_in_addr_192_104_136_apex = mkPersonalSiteRebind { name = "@"; };
    } // mkPurelyMailRecord
    "136.104.192.in-addr.arpa"
    "arpa_in_addr_192_104_136"
  ;
}
