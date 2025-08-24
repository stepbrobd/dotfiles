{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "ysun.co"
    {
      # dependency: all sites using `lib.terranix.mkPersonalSiteRebind`
      co_ysun_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "anycast.as10779.net";
        comment = "CNAME Rebind - Personal Site";
      };
      co_ysun_wildcard = mkPersonalSiteRebind { name = "*"; };

      co_ysun_cache = {
        type = "CNAME";
        proxied = true;
        name = "cache";
        content = "odake.as10779.net";
        comment = "SSDNodes - Tokyo 2 - Hydra";
      };

      co_ysun_ha = {
        type = "CNAME";
        proxied = false;
        name = "ha";
        content = "isere.internal.center";
        comment = "Tailscale Internal - Raspberry Pi - Home Assistant";
      };

      co_ysun_home = {
        type = "CNAME";
        proxied = true;
        name = "home";
        content = "walberla.as10779.net";
        comment = "Hetzner - Glance";
      };

      co_ysun_hydra = {
        type = "CNAME";
        proxied = true;
        name = "hydra";
        content = "odake.as10779.net";
        comment = "SSDNodes - Tokyo 2 - Hydra";
      };

      co_ysun_ldap = {
        type = "CNAME";
        proxied = false;
        name = "ldap";
        content = "walberla.as10779.net";
        comment = "Hetzner - Kanidm";
      };

      # dependency: cloudflare_dns_record.fr_grenug_meet
      co_ysun_meet = {
        type = "CNAME";
        proxied = false;
        name = "meet";
        content = "lagern.as10779.net";
        comment = "AWS - EU Central 2 - Jitsi Meet";
      };

      co_ysun_otel = {
        type = "CNAME";
        proxied = true;
        name = "otel";
        content = "halti.as10779.net";
        comment = "Garnix - Grafana";
      };

      co_ysun_read = {
        type = "CNAME";
        proxied = true;
        name = "read";
        content = "toompea.as10779.net";
        comment = "V.PS - Tallinn, Estonia - Calibre";
      };

      co_ysun_sso = {
        type = "CNAME";
        proxied = true;
        name = "sso";
        content = "walberla.as10779.net";
        comment = "Hetzner - Kanidm";
      };

      # dependency: cloudflare_dns_record.fr_grenug_stats
      co_ysun_stats = {
        type = "CNAME";
        proxied = true;
        name = "stats";
        content = "toompea.as10779.net";
        comment = "V.PS - Tallinn, Estonia - Plausible Analytics";
      };

      co_ysun_tailscale = {
        type = "TXT";
        proxied = false;
        name = "@";
        content = ''"TAILSCALE-aF1t4amerhfObdf0vkPl"'';
        comment = "Tailscale - Verification";
      };

      co_ysun_google = {
        type = "TXT";
        proxied = false;
        name = "@";
        content = ''"google-site-verification=2LutjaV7j2eFT1GaPS5YcbRM5QrX-pZsvzNOYK4i-mQ"'';
        comment = "Google - Search Console";
      };
    } // mkPurelyMailRecord
    "ysun.co"
    "co_ysun"
  ;
}
