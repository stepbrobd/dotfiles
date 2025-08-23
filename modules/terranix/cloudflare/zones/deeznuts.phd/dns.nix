{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "deeznuts.phd"
    {
      phd_deeznuts_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };

      phd_deeznuts_wildcard = {
        type = "CNAME";
        proxied = false;
        name = "*";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };
    } // mkPurelyMailRecord
    "deeznuts.phd"
    "phd_deeznuts"
  ;
}
