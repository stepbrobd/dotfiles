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

  sops.secrets."kanidm/passwd".group = "kanidm";
  sops.secrets."kanidm/passwd".mode = "440";
  sops.secrets."kanidm/oauth/grafana".group = "kanidm";
  sops.secrets."kanidm/oauth/grafana".mode = "440";

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
      acceptInvalidCerts = true;

      adminPasswordFile = config.sops.secrets."kanidm/passwd".path;
      idmAdminPasswordFile = config.sops.secrets."kanidm/passwd".path;

      groups = {
        "sso.admins" = { };
        "sso.users" = { };

        "calibre.admins" = { };
        "calibre.users" = { };

        "hydra.admins" = { };
        "hydra.users" = { };

        "grafana.server-admins" = { };
        "grafana.admins" = { };
        "grafana.editors" = { };
        "grafana.users" = { };
      };

      persons = {
        ysun = {
          displayName = "Yifei";
          legalName = "Yifei Sun";
          mailAddresses = [ "ysun@hey.com" ];
          groups = [
            "sso.admins"
            "sso.users"

            "calibre.admins"
            "calibre.users"

            "hydra.admins"
            "hydra.users"

            "grafana.server-admins"
            "grafana.admins"
            "grafana.editors"
            "grafana.users"
          ];
        };
      };

      systems.oauth2.grafana = {
        displayName = "Grafana";
        originUrl = "https://otel.ysun.co/login/generic_oauth";
        originLanding = "https://otel.ysun.co/";
        # basicSecretFile = config.sops.secrets."kanidm/oauth/grafana".path;
        preferShortUsername = true;
        scopeMaps."grafana.users" = [
          "openid"
          "email"
          "profile"
        ];
        claimMaps.groups = {
          joinType = "array";
          valuesByGroup = {
            "grafana.server-admins" = [ "server_admin" ];
            "grafana.admins" = [ "admin" ];
            "grafana.editors" = [ "editor" ];
          };
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
