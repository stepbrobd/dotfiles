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
    ''"purelymail_ownership_proof=1559fbc37e4cd506bdc8f5737c3f951d0229b1b32c0d72b38d11f40fc9b00676d25a724c5904a7ba1440d46529b3ac8b5101208d5d96a01d2941ed1bd77ed7df"''
  ;
}
