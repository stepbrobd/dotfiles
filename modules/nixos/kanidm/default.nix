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
      import csp
      header  Cache-Control      "private, must-revalidate, max-age=0;"
      header >Cache-Control (.*) "private, must-revalidate, max-age=0;"
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
  sops.secrets."kanidm/oauth/cloudflare".group = "kanidm";
  sops.secrets."kanidm/oauth/cloudflare".mode = "440";
  sops.secrets."kanidm/oauth/hydra".group = "kanidm";
  sops.secrets."kanidm/oauth/hydra".mode = "440";
  sops.secrets."kanidm/oauth/grafana".group = "kanidm";
  sops.secrets."kanidm/oauth/grafana".mode = "440";

  services.kanidm = {
    package = pkgs.kanidm_1_7.withSecretProvisioning.overrideAttrs (prev: {
      # the patch probably only need to inject plausible script now
      # but lets just leave private cache and csp as is in there
      patches = prev.patches ++ [ ./custom-deployment.patch ];
    });

    enableClient = true;
    clientSettings.uri = config.services.kanidm.serverSettings.origin;

    enableServer = true;
    serverSettings = {
      domain = "ysun.co";
      origin = "https://sso.ysun.co";
      trust_x_forward_for = true;

      ldapbindaddress = "[::]:636";
      bindaddress = "[::]:8443";

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

        "cloudflare.admins" = { };
        "cloudflare.users" = { };

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

            "cloudflare.admins"
            "cloudflare.users"

            "hydra.admins"
            "hydra.users"

            "grafana.server-admins"
            "grafana.admins"
            "grafana.editors"
            "grafana.users"
          ];
        };
      };

      systems.oauth2 = {
        cloudflare = {
          displayName = "Cloudflare";
          originUrl = "https://stepbrobd.cloudflareaccess.com/cdn-cgi/access/callback";
          originLanding = "https://stepbrobd.cloudflareaccess.com/";
          basicSecretFile = config.sops.secrets."kanidm/oauth/cloudflare".path;
          preferShortUsername = true;
          scopeMaps."grafana.users" = [
            "openid"
            "email"
            "profile"
          ];
        };

        hydra = {
          displayName = "Hydra";
          allowInsecureClientDisablePkce = true;
          originUrl = "https://hydra.ysun.co/oidc-login";
          originLanding = "https://hydra.ysun.co/";
          basicSecretFile = config.sops.secrets."kanidm/oauth/hydra".path;
          preferShortUsername = true;
          scopeMaps."hydra.users" = [
            "openid"
            "email"
            "profile"
            "groups"
          ];
        };

        grafana = {
          displayName = "Grafana";
          originUrl = "https://otel.ysun.co/login/generic_oauth";
          originLanding = "https://otel.ysun.co/";
          basicSecretFile = config.sops.secrets."kanidm/oauth/grafana".path;
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
  };

  users.groups.sso.members = [ "caddy" "kanidm" ];
  security.acme.certs."sso.ysun.co" = {
    domain = "sso.ysun.co";
    extraDomainNames = [ "ldap.ysun.co" ];
    group = "sso";
    reloadServices = [ "caddy.service" "kanidm.service" ];
  };
}
