{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "xdg.sh"
    {
      sh_xdg_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };

      sh_xdg_wildcard = {
        type = "CNAME";
        proxied = false;
        name = "*";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };
    } // mkPurelyMailRecord
    "xdg.sh"
    "sh_xdg"
  ;
}
