{ lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) genAttrs mkIf mkOption toString types;

  cfg = config.services.plausible;
in
{
  options.services.plausible = {
    domain = mkOption {
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

    services.plausible = {
      package = pkgs.plausible.overrideAttrs (_: {
        prePatch = ''
          substituteInPlace lib/plausible_web/templates/layout/app.html.heex \
            --replace-warn '</head>' '<script defer data-domain="${cfg.domain}" src="/js/script.file-downloads.hash.outbound-links.js"></script></head>'
        '';
      });

      mail = {
        email = "noc@stepbrobd.com";
        smtp = {
          enableSSL = true;
          hostAddr = "smtp.purelymail.com";
          hostPort = 465;
          passwordFile = config.sops.secrets."plausible/smtp".path;
          user = "ysun@purelymail.com";
        };
      };

      server = {
        baseUrl = "https://${cfg.domain}";
        disableRegistration = "invite_only";
        listenAddress = "127.0.0.1";
        port = 20069;
        secretKeybaseFile = config.sops.secrets."plausible/keybase".path;
      };
    };

    services.caddy = {
      virtualHosts = genAttrs ([ cfg.domain ] ++ cfg.extraDomains) (domain: {
        extraConfig = with config.services.plausible.server; ''
          import common
          reverse_proxy ${toString listenAddress}:${toString port} {
            header_up Host {host}
            header_up X-Real-IP {http.request.header.CF-Connecting-IP}
          }
        '';
      });
    };
  };
}
