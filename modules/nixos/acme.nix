{ config, ... }:

{
  sops.secrets.acme = { };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ysun@hey.com";
      dnsProvider = "cloudflare";
      extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
      environmentFile = config.sops.secrets.acme.path;
    };
  };
}
