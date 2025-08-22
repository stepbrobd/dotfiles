let
  mkRecord = zone: record: record // {
    zone_id = ''''${data.sops_file.secrets.data["cloudflare.zone_id.${zone}"]}'';
    ttl = 1;
  };
in
{
  imports = [ ./providers.nix ];

  resource.cloudflare_dns_record = {
    fr_grenug_dmarc = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = false;
      name = "_dmarc.grenug.fr";
      content = "dmarcroot.purelymail.com";
      comment = "Purelymail - Custom Domain";
    };

    fr_grenug_wildcard = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = true;
      name = "*.grenug.fr";
      content = "grenug.fr";
    };

    fr_grenug_meet = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = false;
      name = "meet.grenug.fr";
      content = "lagern.as10779.net";
      comment = "AWS - EU Central 2 - Jitsi Meet";
    };

    fr_grenug_purelymail1_domainkey = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = false;
      name = "purelymail1._domainkey.grenug.fr";
      content = "key1.dkimroot.purelymail.com";
      comment = "Purelymail - Custom Domain";
    };

    fr_grenug_purelymail2_domainkey = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = false;
      name = "purelymail2._domainkey.grenug.fr";
      content = "key2.dkimroot.purelymail.com";
      comment = "Purelymail - Custom Domain";
    };

    fr_grenug_purelymail3_domainkey = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = false;
      name = "purelymail3._domainkey.grenug.fr";
      content = "key3.dkimroot.purelymail.com";
      comment = "Purelymail - Custom Domain";
    };

    fr_grenug_stats = mkRecord "grenug.fr" {
      type = "CNAME";
      proxied = true;
      name = "stats.grenug.fr";
      content = "toompea.as10779.net";
      comment = "V.PS - Tallinn, Estonia - Plausible Analytics";
    };

    fr_grenug_mx = mkRecord "grenug.fr" {
      type = "MX";
      proxied = false;
      name = "grenug.fr";
      content = "mailserver.purelymail.com";
      comment = "Purelymail - Custom Domain";
      priority = 1;
    };

    fr_grenug_atproto = mkRecord "grenug.fr" {
      type = "TXT";
      proxied = false;
      name = "_atproto.grenug.fr";
      content = "did=did:plc:2avqf3fyabzocrmygamzdenj";
      comment = "Bluesky - Domain Verification";
    };

    fr_grenug_spf = mkRecord "grenug.fr" {
      type = "TXT";
      proxied = false;
      name = "grenug.fr";
      content = "v=spf1 include:_spf.purelymail.com ~all";
      comment = "Purelymail - Custom Domain";
    };

    fr_grenug_ownership = mkRecord "grenug.fr" {
      type = "TXT";
      proxied = false;
      name = "grenug.fr";
      content = "purelymail_ownership_proof=1559fbc37e4cd506bdc8f5737c3f951d0229b1b32c0d72b38d11f40fc9b00676d25a724c5904a7ba1440d46529b3ac8b5101208d5d96a01d2941ed1bd77ed7df";
      comment = "Purelymail - Custom Domain";
    };

    fr_grenug_aaaa = mkRecord "grenug.fr" {
      type = "AAAA";
      proxied = true;
      name = "grenug.fr";
      content = "100::";
    };
  };
}
