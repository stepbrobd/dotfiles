{ inputs, ... }:

{ config, ... }:

{
  age.secrets.acme.file = "${inputs.self}/secrets/cloudflare-acme.age";

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "ysun@hey.com";
      dnsProvider = "cloudflare";
      extraLegoFlags = [ "--dns.resolvers=1.1.1.1:53" ];
      environmentFile = config.age.secrets.acme.path;
    };
  };
}
