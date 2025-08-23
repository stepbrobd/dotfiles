{ lib }:

rec {
  provider = {
    cloudflare = {
      terraform.required_providers.cloudflare.source = "cloudflare/cloudflare";
      provider.cloudflare = {
        email = ''''${data.sops_file.secrets.data["cloudflare.email"]}'';
        api_key = ''''${data.sops_file.secrets.data["cloudflare.api_key"]}'';
      };
    };

    sops = {
      terraform.required_providers.sops.source = "carlpett/sops";
      provider.sops = { };
      data.sops_file.secrets.source_file = lib.toString ./secrets.yaml;
    };
  };

  mkZone = zone: lib.mapAttrs (_: record: mkRecord zone record);

  mkRecord =
    zone: record: {
      zone_id = ''''${data.sops_file.secrets.data["cloudflare.zone_id.${zone}"]}'';
      ttl = 1;
    } // record;

  mkPurelyMailRecord =
    let
      comment = "Purelymail - Custom Domain";
    in
    zone: prefix: ownership: mkZone zone {
      "${prefix}_purelymail_mx" = {
        inherit comment;
        type = "MX";
        proxied = false;
        name = "@";
        content = "mailserver.purelymail.com";
        priority = 1;
      };
      "${prefix}_purelymail_spf" = {
        inherit comment;
        type = "TXT";
        proxied = false;
        name = "@";
        content = ''"v=spf1 include:_spf.purelymail.com ~all"'';
      };
      "${prefix}_purelymail_ownership" = {
        inherit comment;
        type = "TXT";
        proxied = false;
        name = "@";
        content = ownership;
      };
      "${prefix}_purelymail_dkim1" = {
        inherit comment;
        type = "CNAME";
        proxied = false;
        name = "purelymail1._domainkey";
        content = "key1.dkimroot.purelymail.com";
      };
      "${prefix}_purelymail_dkim2" = {
        inherit comment;
        type = "CNAME";
        proxied = false;
        name = "purelymail2._domainkey";
        content = "key2.dkimroot.purelymail.com";
      };
      "${prefix}_purelymail_dkim3" = {
        inherit comment;
        type = "CNAME";
        proxied = false;
        name = "purelymail3._domainkey";
        content = "key3.dkimroot.purelymail.com";
      };
      "${prefix}_purelymail_dmarc" = {
        inherit comment;
        type = "CNAME";
        proxied = false;
        name = "_dmarc";
        content = "dmarcroot.purelymail.com";
      };
    };
}
