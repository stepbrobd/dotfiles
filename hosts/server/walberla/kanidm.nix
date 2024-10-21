{ config, pkgs, ... }:

{
  # allow port 636 for LDAP
  networking.firewall.allowedTCPPorts = [ 636 ];

  services.kanidm = {
    enableServer = true;

    serverSettings =
      let
        inherit (config.security.acme.certs."auth.ysun.co") directory;
      in
      {
        domain = "ysun.co";
        origin = "https://auth.ysun.co";
        ldapbindaddress = "0.0.0.0:636";
        bindaddress = "0.0.0.0:8080";
        trust_x_forward_for = true;
        tls_key = "${directory}/key.pem";
        tls_chain = "${directory}/fullchain.pem";
      };
  };

  security.acme.certs."auth.ysun.co" = {
    postRun = "systemctl restart kanidm.service";
    group = "kanidm";
  };
}
