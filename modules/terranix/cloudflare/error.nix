{ lib, ... }:

{ ... }:

let
  inherit (lib) mapAttrs' nameValuePair;

  # account level custom error pages
  pages = {
    basic_challenge = "challenge";
    country_challenge = "challenge";
    managed_challenge = "challenge";
    under_attack = "challenge";
    ip_block = "waf";
    waf_block = "waf";
    ratelimit_block = "widget";
    "500_errors" = "widget";
    "1000_errors" = "widget";
  };
in
{
  resource.cloudflare_custom_pages = mapAttrs'
    (identifier: page: nameValuePair "error_${identifier}" {
      account_id = ''''${data.sops_file.secrets.data["cloudflare.account_id"]}'';
      inherit identifier;
      state = "customized";
      url = "https://stepbrobd.com/error/${page}";
    })
    pages;
}
