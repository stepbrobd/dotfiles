{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPurelyMailRecord tfRef;
in
{
  resource.cloudflare_dns_record = forZone "grenug.fr"
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
        name = "meet";
        proxied = tfRef "cloudflare_dns_record.co_ysun_meet.proxied";
        content = tfRef "cloudflare_dns_record.co_ysun_meet.content";
        comment = tfRef "cloudflare_dns_record.co_ysun_meet.comment";
      };

      fr_grenug_stats = {
        type = "CNAME";
        name = "stats";
        proxied = tfRef "cloudflare_dns_record.co_ysun_stats.proxied";
        content = tfRef "cloudflare_dns_record.co_ysun_stats.content";
        comment = tfRef "cloudflare_dns_record.co_ysun_stats.comment";
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
