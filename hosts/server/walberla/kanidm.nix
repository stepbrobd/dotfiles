{ config, pkgs, ... }:

let
  inherit (config.security.acme.certs."sso.ysun.co") directory;
in
{
  networking.firewall.allowedTCPPorts = [ 636 ];

  environment.systemPackages = with pkgs; [ kanidm ];

  services.caddy = {
    enable = true;
    virtualHosts."sso.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${config.services.kanidm.serverSettings.bindaddress} {
        tls "${directory}/fullchain.pem" "${directory}/key.pem"
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
      }
    '';
  };

  services.kanidm = {
    enableClient = true;
    clientSettings.uri = config.services.kanidm.serverSettings.origin;

    enableServer = true;
    serverSettings = {
      domain = "ysun.co";
      origin = "https://sso.ysun.co";
      ldapbindaddress = "0.0.0.0:636";
      bindaddress = "0.0.0.0:40069";
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
