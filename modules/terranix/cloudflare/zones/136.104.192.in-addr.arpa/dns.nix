{ lib, ... }:

let
  inherit (lib.terranix) mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkPurelyMailRecord
    "136.104.192.in-addr.arpa"
    "arpa_in_addr_192_104_136"
  ;
}
