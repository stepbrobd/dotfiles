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
      tls "${directory}/fullchain.pem" "${directory}/key.pem"
      reverse_proxy ${config.services.kanidm.provision.instanceUrl} {
        header_up Host {host}
        header_up X-Real-IP {http.request.header.CF-Connecting-IP}
        transport http {
            tls_server_name sso.ysun.co
        }
      }
    '';
  };

  sops.secrets.kanidm = {
    owner = "kanidm";
    group = "kanidm";
  };

  services.kanidm = {
    package = pkgs.kanidm.override { enableSecretProvisioning = true; };

    enableClient = true;
    clientSettings.uri = config.services.kanidm.serverSettings.origin;

    enableServer = true;
    serverSettings = {
      domain = "ysun.co";
      origin = "https://sso.ysun.co";
      trust_x_forward_for = true;

      ldapbindaddress = "0.0.0.0:636";
      bindaddress = "0.0.0.0:8443";

      tls_key = "${directory}/key.pem";
      tls_chain = "${directory}/fullchain.pem";
    };

    provision = {
      enable = true;
      autoRemove = true;
      # acceptInvalidCerts = true;

      adminPasswordFile = config.sops.secrets.kanidm.path;
      idmAdminPasswordFile = config.sops.secrets.kanidm.path;

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
          groups = [ "sso.admins" "sso.users" "hydra.admins" "hydra.users" ];
        };
      };
    };
  };

  users.groups.sso.members = [ "caddy" "kanidm" ];
  security.acme.certs."sso.ysun.co" = {
    domain = "sso.ysun.co";
    extraDomainNames = [ "ldap.ysun.co" ];
    group = "sso";
    reloadServices = [ "caddy.service" "kanidm.service" ];
  };
}
