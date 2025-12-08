{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "as10779.net"
    {
      net_as10779_apex = mkPersonalSiteRebind { name = "@"; };
      net_as10779_wildcard = mkPersonalSiteRebind { name = "*"; };

      net_as10779_anycast_v4 = {
        type = "A";
        proxied = false;
        name = "anycast";
        content = "23.161.104.17";
        comment = "AS10779 - Anycast";
      };

      net_as10779_anycast_v6 = {
        type = "AAAA";
        proxied = false;
        name = "anycast";
        content = "2602:f590::23:161:104:17";
        comment = "AS10779 - Anycast";
      };

      net_as10779_butte_v4 = {
        type = "A";
        proxied = false;
        name = "butte";
        content = "23.161.104.132";
        comment = "Virtua - Paris";
      };

      net_as10779_butte_v6 = {
        type = "AAAA";
        proxied = false;
        name = "butte";
        content = "2602:f590::23:161:104:132";
        comment = "Virtua - Paris";
      };

      net_as10779_halti_v4 = {
        type = "A";
        proxied = false;
        name = "halti";
        content = "37.27.181.83";
        comment = "Garnix - Hosting";
      };

      net_as10779_halti_v6 = {
        type = "AAAA";
        proxied = false;
        name = "halti";
        content = "2a01:4f9:c012:7b3a::1";
        comment = "Garnix - Hosting";
      };

      net_as10779_highline_v4 = {
        type = "A";
        proxied = false;
        name = "highline";
        content = "23.161.104.129";
        comment = "Neptune - New York";
      };

      net_as10779_highline_v6 = {
        type = "AAAA";
        proxied = false;
        name = "highline";
        content = "2602:f590::23:161:104:129";
        comment = "Neptune - New York";
      };

      net_as10779_kongo_v4 = {
        type = "A";
        proxied = false;
        name = "kongo";
        content = "23.161.104.130";
        comment = "Vultr - Osaka";
      };

      net_as10779_kongo_v6 = {
        type = "AAAA";
        proxied = false;
        name = "kongo";
        content = "2602:f590::23:161:104:130";
        comment = "Vultr - Osaka";
      };

      net_as10779_lagern_v4 = {
        type = "A";
        proxied = false;
        name = "lagern";
        content = "16.62.113.214";
        comment = "AWS - EU Central 2";
      };

      net_as10779_lagern_v6 = {
        type = "AAAA";
        proxied = false;
        name = "lagern";
        content = "2a05:d019:b00:b6f0:6981:b7c5:ff97:9eea";
        comment = "AWS - EU Central 2";
      };

      net_as10779_odake_v4 = {
        type = "A";
        proxied = false;
        name = "odake";
        content = "209.182.234.194";
        comment = "SSDNodes - Tokyo 2";
      };

      net_as10779_odake_v6 = {
        type = "AAAA";
        proxied = false;
        name = "odake";
        content = "2602:ff16:14:0:1:56:0:1";
        comment = "SSDNodes - Tokyo 2";
      };

      net_as10779_timah_v4 = {
        type = "A";
        proxied = false;
        name = "timah";
        content = "23.161.104.131";
        comment = "Misaka - Singapore";
      };

      net_as10779_timah_v6 = {
        type = "AAAA";
        proxied = false;
        name = "timah";
        content = "2602:f590::23:161:104:131";
        comment = "Misaka - Singapore";
      };

      net_as10779_toompea_v4 = {
        type = "A";
        proxied = false;
        name = "toompea";
        content = "23.161.104.128";
        comment = "xTom - Tallinn, Estonia";
      };

      net_as10779_toompea_v6 = {
        type = "AAAA";
        proxied = false;
        name = "toompea";
        content = "2602:f590::23:161:104:128";
        comment = "xTom - Tallinn, Estonia";
      };

      net_as10779_walberla_v4 = {
        type = "A";
        proxied = false;
        name = "walberla";
        content = "23.88.126.45";
        comment = "Hetzner - Falkenstein";
      };

      net_as10779_walberla_v6 = {
        type = "AAAA";
        proxied = false;
        name = "walberla";
        content = "2a01:4f8:c17:4b75::1";
        comment = "Hetzner - Falkenstein";
      };
    } // mkPurelyMailRecord
    "as10779.net"
    "net_as10779"
  ;
}
