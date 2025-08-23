{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "ysun.life"
    {
      life_ysun_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };

      life_ysun_wildcard = {
        type = "CNAME";
        proxied = false;
        name = "*";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };
    } // mkPurelyMailRecord
    "ysun.life"
    "life_ysun"
  ;
}
