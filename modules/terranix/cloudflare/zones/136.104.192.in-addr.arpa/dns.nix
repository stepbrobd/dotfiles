{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "136.104.192.in-addr.arpa"
    {
      arpa_in_addr_192_104_136_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };
    } // mkPurelyMailRecord
    "136.104.192.in-addr.arpa"
    "arpa_in_addr_192_104_136"
  ;
}
