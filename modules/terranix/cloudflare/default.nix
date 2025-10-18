{ lib, ... } @ args:

{ ... }:

let
  inherit (lib) map filter attrNames readDir;
  inherit (lib.terranix) acnsSettings;
in
{
  imports = map
    (f: import ./${f} args)
    (filter
      (f: f != "default.nix")
      (attrNames (readDir ./.)));

  resource.cloudflare_account_dns_settings.settings = acnsSettings;

  resource.cloudflare_zero_trust_access_identity_provider.idp = {
    account_id = ''''${data.sops_file.secrets.data["cloudflare.account_id"]}'';
    name = "OpenID Connect";
    type = "oidc";

    # oidc config
    config = {
      client_id = ''''${data.sops_file.secrets.data["cloudflare.sso_client_id"]}'';
      client_secret = ''''${data.sops_file.secrets.data["cloudflare.sso_client_secret"]}'';

      auth_url = "https://sso.ysun.co/ui/oauth2";
      token_url = "https://sso.ysun.co/oauth2/token";
      certs_url = "https://sso.ysun.co/oauth2/openid/cloudflare/public_key.jwk";

      pkce_enabled = true;

      scopes = [
        "openid"
        "email"
        "profile"
      ];
    };

    # kanidm have no support for scim yet
    scim_config = rec {
      enabled = false;
      user_deprovision = enabled;
      seat_deprovision = enabled;
      group_member_deprovision = enabled;
      identity_update_behavior = "automatic";
    };
  };
}
