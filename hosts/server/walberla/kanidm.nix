{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 443 636 ];

  environment.systemPackages = with pkgs; [ kanidm ];

  services.kanidm = {
    enableClient = true;
    clientSettings.uri = config.services.kanidm.serverSettings.origin;

    enableServer = true;
    serverSettings =
      let
        inherit (config.security.acme.certs."sso.ysun.co") directory;
      in
      {
        domain = "ysun.co";
        origin = "https://sso.ysun.co";
        ldapbindaddress = "0.0.0.0:636";
        bindaddress = "0.0.0.0:443";
        trust_x_forward_for = true;
        tls_key = "${directory}/key.pem";
        tls_chain = "${directory}/fullchain.pem";
      };

    provision = {
      enable = true;
      autoRemove = true;
      instanceUrl = config.services.kanidm.serverSettings.origin;
      acceptInvalidCerts = true;

      groups = {
        "sso.admins" = { };
        "sso.users" = { };
        "hydra.admins" = { };
        "hydra.users" = { };
      };

      persons = {
        ysun = {
          displayName = "Yifei";
          legalName = "Yifei Sun";
          mailAddresses = [ "ysun@hey.com" ];
          groups = [ "sso.admins" "hydra.admins" ];
        };
      };
    };
  };

  security.acme.certs."sso.ysun.co" = {
    postRun = "systemctl restart kanidm.service";
    group = "kanidm";
  };
}
