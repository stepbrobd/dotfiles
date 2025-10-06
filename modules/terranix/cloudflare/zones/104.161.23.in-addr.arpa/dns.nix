{ lib, ... }:

let
  inherit (lib.terranix) forZone mkPersonalSiteRebind mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = forZone "104.161.23.in-addr.arpa"
    {
      arpa_in_addr_23_161_104_apex = mkPersonalSiteRebind { name = "@"; proxied = true; };

      arpa_in_addr_23_161_104_17 = {
        type = "PTR";
        proxied = false;
        name = "17";
        content = "anycast.as10779.net";
        comment = "AS10779 - Anycast";
      };

      arpa_in_addr_23_161_104_128 = {
        type = "PTR";
        proxied = false;
        name = "128";
        content = "toompea.as10779.net";
        comment = "xTom - Tallinn, Estonia";
      };

      arpa_in_addr_23_161_104_129 = {
        type = "PTR";
        proxied = false;
        name = "129";
        content = "highline.as10779.net";
        comment = "Neptune - New York";
      };

      arpa_in_addr_23_161_104_130 = {
        type = "PTR";
        proxied = false;
        name = "130";
        content = "kongo.as10779.net";
        comment = "Vultr - Osaka";
      };

      arpa_in_addr_23_161_104_132 = {
        type = "PTR";
        proxied = false;
        name = "132";
        content = "butte.as10779.net";
        comment = "Virtua - Paris";
      };
    } // mkPurelyMailRecord
    "104.161.23.in-addr.arpa"
    "arpa_in_addr_23_161_104"
  ;
}
