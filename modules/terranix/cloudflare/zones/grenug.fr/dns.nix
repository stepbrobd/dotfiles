{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "grenug.fr"
    {
      fr_grenug_wildcard = {
        type = "CNAME";
        proxied = true;
        name = "*";
        content = "grenug.fr";
        comment = "Cloudflare Workers - Grenuble Nix User Group";
      };

      fr_grenug_meet = {
        type = "CNAME";
        proxied = false;
        name = "meet";
        content = "lagern.as10779.net";
        comment = "AWS - EU Central 2 - Jitsi Meet";
      };

      fr_grenug_stats = {
        type = "CNAME";
        proxied = true;
        name = "stats";
        content = "toompea.as10779.net";
        comment = "V.PS - Tallinn, Estonia - Plausible Analytics";
      };

      fr_grenug_atproto = {
        type = "TXT";
        proxied = false;
        name = "_atproto";
        content = ''"did=did:plc:2avqf3fyabzocrmygamzdenj"'';
        comment = "Bluesky - Domain Verification";
      };
    } // mkPurelyMailRecord
    "grenug.fr"
    "fr_grenug"
  ;
}
