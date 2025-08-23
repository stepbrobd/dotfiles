{ lib, ... }:

let
  inherit (lib.terranix) mkZone mkPurelyMailRecord;
in
{
  resource.cloudflare_dns_record = mkZone "0.0.9.5.f.2.0.6.2.ip6.arpa"
    {
      arpa_ip6_2_6_0_2_f_5_9_0_0_apex = {
        type = "CNAME";
        proxied = false;
        name = "@";
        content = "ysun.co";
        comment = "CNAME Rebind - Personal Site";
      };

      arpa_ip6_2_6_0_2_f_5_9_0_0_0_0_0_0_2_3_1_6_1_0_1_4_0_0_1_7 = {
        type = "PTR";
        proxied = false;
        name = "7.1.0.0.4.0.1.0.1.6.1.0.3.2.0.0.0.0.0.0.0.0.0";
        content = "anycast.as10779.net";
        comment = "AS10779 - Anycast";
      };

      arpa_ip6_2_6_0_2_f_5_9_0_0_0_0_0_0_2_3_1_6_1_0_1_4_0_1_2_8 = {
        type = "PTR";
        proxied = false;
        name = "8.2.1.0.4.0.1.0.1.6.1.0.3.2.0.0.0.0.0.0.0.0.0";
        content = "toompea.as10779.net";
        comment = "xTom - Tallinn, Estonia";
      };

      arpa_ip6_2_6_0_2_f_5_9_0_0_0_0_0_0_2_3_1_6_1_0_1_4_0_1_2_9 = {
        type = "PTR";
        proxied = false;
        name = "9.2.1.0.4.0.1.0.1.6.1.0.3.2.0.0.0.0.0.0.0.0.0";
        content = "highline.as10779.net";
        comment = "Neptune - New York";
      };

      arpa_ip6_2_6_0_2_f_5_9_0_0_0_0_0_0_2_3_1_6_1_0_1_4_0_1_3_0 = {
        type = "PTR";
        proxied = false;
        name = "0.3.1.0.4.0.1.0.1.6.1.0.3.2.0.0.0.0.0.0.0.0.0";
        content = "kongo.as10779.net";
        comment = "Vultr - Osaka";
      };

      arpa_ip6_2_6_0_2_f_5_9_0_0_0_0_0_0_2_3_1_6_1_0_1_4_0_1_3_2 = {
        type = "PTR";
        proxied = false;
        name = "2.3.1.0.4.0.1.0.1.6.1.0.3.2.0.0.0.0.0.0.0.0.0";
        content = "butte.as10779.net";
        comment = "Virtua - Paris";
      };

    } // mkPurelyMailRecord
    "0.0.9.5.f.2.0.6.2.ip6.arpa"
    "arpa_ip6_2_6_0_2_f_5_9_0_0"
  ;
}
