{ inputs, ... }:

{ config, ... }:

{
  age.secrets.acme.file = "${inputs.self}/secrets/cloudflare-acme.age";

  security.acme.defaults = {
    email = "ysun@hey.com";
    dnsProvider = "cloudflare";
    environmentFile = config.age.secrets.acme.path;
  };
}
