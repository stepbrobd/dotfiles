{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "xdg.sh"
    {
      sh_xdg_apex = mkPersonalSiteRebind { name = "@"; };
      sh_xdg_wildcard = mkPersonalSiteRebind { name = "*"; };
    } // mkPurelyMailRecord
    "xdg.sh"
    "sh_xdg"
  ;
}
