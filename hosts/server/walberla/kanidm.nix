{ config, pkgs, ... }:

let
  domain = "auth.ysun.co";
  caddyDir = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory";
in
{
  services.kanidm = {
    enableServer = true;

    serverSettings = {
      inherit domain;
      origin = "https://${domain}";
      ldapbindaddress = "0.0.0.0:636";
      bindaddress = "0.0.0.0:8080";
      trust_x_forward_for = true;
      tls_key = "${caddyDir}/${domain}/${domain}.key";
      tls_chain = "${caddyDir}/${domain}/${domain}.crt";
    };
  };

  # kanidm have read access to cadddy certificates
  systemd.services.kanidm.preStart = ''
    ${pkgs.acl}/bin/setfacl -m user:kanidm:r ${config.services.kanidm.serverSettings.tls_key}
    ${pkgs.acl}/bin/setfacl -m user:kanidm:r ${config.services.kanidm.serverSettings.tls_chain}

    ${pkgs.acl}/bin/setfacl -m group:kanidm:r ${config.services.kanidm.serverSettings.tls_key}
    ${pkgs.acl}/bin/setfacl -m group:kanidm:r ${config.services.kanidm.serverSettings.tls_chain}
  '';
}
