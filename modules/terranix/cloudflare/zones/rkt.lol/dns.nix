{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "rkt.lol"
    {
      lol_rkt_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };

      lol_rkt_wildcard = {
        type = "CNAME";
        proxied = false;
        name = "*";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };
    } // mkPurelyMailRecord
    "rkt.lol"
    "lol_rkt"
  ;
}
