{ lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) mkIf mkOption toString types;

  cfg = config.services.plausible;
in
{
  options.services.plausible = {
    mainDomain = mkOption {
      default = "stats.ysun.co";
      description = "Main domain to serve plausible analytics on";
      example = "stats.ysun.co";
      type = types.str;
    };

    extraDomains = mkOption {
      default = [ ];
      description = "List of extra domains aside from main domain to serve plausible analytics on";
      example = [ "stats.ysun.co" ];
      type = types.listOf types.str;
    };
  };

  config = mkIf config.services.plausible.enable {
    services.caddy.enable = true;

    sops.secrets."plausible/smtp" = { };
    sops.secrets."plausible/keybase" = { };
    sops.secrets."plausible/environment" = { };
    systemd.services.plausible.serviceConfig.EnvironmentFile = [
      config.sops.secrets."plausible/environment".path
    ];

    # sso feature is guarded
    # https://github.com/plausible/analytics/blob/master/config/.env.load
    systemd.services.plausible.environment.SSO_ENABLED = "true";

    # clickhouse eats massive amount of disk space
    # disable logging to save space
    # https://github.com/plausible/hosting/tree/master/clickhouse
    # https://github.com/NixOS/nixpkgs/issues/196935
    # https://github.com/NixOS/nixpkgs/issues/245024
    environment.etc = {
      "clickhouse-server/config.d/nologs.xml".text = ''
        <clickhouse>
            <logger>
                <level>warning</level>
                <console>true</console>
            </logger>
            <query_thread_log remove="remove"/>
            <query_log remove="remove"/>
            <text_log remove="remove"/>
            <trace_log remove="remove"/>
            <metric_log remove="remove"/>
            <asynchronous_metric_log remove="remove"/>
            <session_log remove="remove"/>
            <part_log remove="remove"/>
        </clickhouse>
      '';
      "clickhouse-server/users.d/nologs.xml".text = ''
        <clickhouse>
            <profiles>
                <default>
                    <log_queries>0</log_queries>
                    <log_query_threads>0</log_query_threads>
                </default>
            </profiles>
        </clickhouse>
      '';
    };

    services.plausible = {
      package = pkgs.plausible.overrideAttrs (_: {
        prePatch = ''
          substituteInPlace lib/plausible_web/templates/layout/app.html.heex \
            --replace-fail '</head>' '<script defer data-domain="${cfg.mainDomain}" src="/js/script.file-downloads.hash.outbound-links.js"></script></head>'
        '';
      });

      mail = {
        email = "noc@stepbrobd.com";
        smtp = {
          enableSSL = true;
          hostAddr = "smtp.purelymail.com";
          hostPort = 465;
          passwordFile = config.sops.secrets."plausible/smtp".path;
          user = "ysun@stepbrobd.com";
        };
      };

      server = {
        baseUrl = "https://${cfg.mainDomain}";
        disableRegistration = "invite_only";
        listenAddress = "127.0.0.1";
        port = 20069;
        secretKeybaseFile = config.sops.secrets."plausible/keybase".path;
      };
    };

    services.caddy = {
      virtualHosts.${cfg.mainDomain} = {
        serverAliases = cfg.extraDomains;
        extraConfig = with config.services.plausible.server; ''
          import common
          reverse_proxy ${toString listenAddress}:${toString port} {
            header_up Host {host}
            header_up X-Real-IP {http.request.header.CF-Connecting-IP}
          }
        '';
      };
    };
  };
}
