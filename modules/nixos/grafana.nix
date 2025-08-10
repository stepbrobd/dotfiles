{ lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) mkIf mkOption toString types;

  cfg = config.services.grafana;
in
{
  options.services.grafana = {
    mainDomain = mkOption {
      default = "otel.ysun.co";
      description = "Main domain to serve grafana on";
      example = "otel.ysun.co";
      type = types.str;
    };

    extraDomains = mkOption {
      default = [ ];
      description = "List of extra domains aside from main domain to serve grafana on";
      example = [ "otel.ysun.co" ];
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      virtualHosts.${cfg.mainDomain} = {
        serverAliases = cfg.extraDomains;
        extraConfig = with config.services.grafana.settings.server; ''
          import common
          reverse_proxy ${toString http_addr}:${toString http_port} {
            header_up Host {host}
            header_up X-Real-IP {http.request.header.CF-Connecting-IP}
          }
        '';
      };
    };

    sops.secrets."grafana/oauth".group = "grafana";
    sops.secrets."grafana/oauth".mode = "440";
    sops.secrets."grafana/smtp".group = "grafana";
    sops.secrets."grafana/smtp".mode = "440";

    services.grafana = {
      package = pkgs.grafana.overrideAttrs (_: {
        preFixup = ''
          substituteInPlace $out/share/grafana/public/views/index.html \
            --replace-fail '</head>' '<script defer data-domain="${cfg.mainDomain}" src="https://stats.ysun.co/js/script.file-downloads.hash.outbound-links.js"></script></head>'
        '';
      });

      declarativePlugins = with pkgs.grafanaPlugins; [
        (grafana-oncall-app.overrideAttrs (_: {
          version = "1.14.3";
          src = pkgs.fetchurl {
            name = "grafana-oncall-app-1.14.3.zip";
            url = "https://grafana.com/api/plugins/grafana-oncall-app/versions/1.14.3/download";
            hash = "sha256-Mmo+cbNyXps1akhB6F6slmpfINHUD2B0EAmawkwjLGE=";
          };
        }))
        yesoreyeram-infinity-datasource
      ];

      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 25000;
          domain = cfg.mainDomain;
          root_url = "https://${cfg.mainDomain}/";
        };

        # oncall
        # https://github.com/grafana/oncall/issues/5100#issuecomment-2490645666
        auth.managed_service_accounts_enabled = true;
        # https://github.com/grafana/oncall/issues/4829#issuecomment-2567046523
        environment.stack_id = 5;
        # https://github.com/grafana/oncall/issues/4829
        # https://github.com/grafana/oncall/issues/5100#issuecomment-2515653591
        feature_toggles = {
          accessControlOncall = false;
          enable = "externalServiceAccounts,featureToggleAdminPage";
        };

        analytics = {
          check_for_updates = false;
          feedback_links_enabled = false;
          reporting_enabled = false;
        };

        security = {
          cookie_secure = true;
          csrf_trusted_origins = [ "https://ysun.co" "https://*.ysun.co" ];
          disable_initial_admin_creation = true;
          hide_version = true;
        };

        users = {
          allow_org_create = false;
          allow_sign_up = false;
        };

        "auth.anonymous".org_name = "StepBroBD, Inc.";
        auth.disable_login_form = true;
        "auth.generic_oauth" = {
          enabled = true;
          name = "Kanidm";
          icon = "signin";
          allow_sign_up = true;
          auto_login = true;
          client_id = "grafana";
          client_secret = "$__file{${config.sops.secrets."grafana/oauth".path}}";
          scopes = "openid email profile";
          login_attribute_path = "preferred_username";
          use_pkce = true;
          allow_assign_grafana_admin = true;
          role_attribute_path = "contains(groups[*], 'server_admin') && 'GrafanaAdmin' || contains(groups[*], 'admin') && 'Admin' || contains(groups[*], 'editor') && 'Editor' || 'Viewer'";
          auth_url = "https://sso.ysun.co/ui/oauth2";
          token_url = "https://sso.ysun.co/oauth2/token";
          api_url = "https://sso.ysun.co/oauth2/openid/grafana/userinfo";
        };

        smtp = {
          enabled = true;
          user = "ysun@stepbrobd.com";
          password = "$__file{${config.sops.secrets."grafana/smtp".path}}";
          host = "smtp.purelymail.com:587";
          startTLS_policy = "MandatoryStartTLS";
          from_address = "noc@stepbrobd.com";
        };
      };
    };
  };
}
