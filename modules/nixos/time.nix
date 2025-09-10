{ lib, ... }:

{ config, ... }:

let
  bind = "127.0.0.1";
  port = 9975;

  serverConfig = config.services.ntpd-rs.server;
in
{
  options.services.ntpd-rs.server = {
    enable = lib.mkEnableOption "enable NTP server with NTS support using ntpd-rs";
    acceptedVersions = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "NTP versions accepted by NTP and NTS-KE server";
      default = [ 4 5 ];
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "Domain name for NTS certificate";
    };
    cert = {
      key = lib.mkOption {
        type = lib.types.path;
        description = "Path to key.pem for NTS certificate";
        default = "${config.security.acme.certs.${serverConfig.domain}.directory}/key.pem";
      };
      fullchain = lib.mkOption {
        type = lib.types.path;
        description = "Path to fullchain.pem for NTS certificate";
        default = "${config.security.acme.certs.${serverConfig.domain}.directory}/fullchain.pem";
      };
    };
  };

  config = lib.mkMerge [
    {
      services.timesyncd.enable = lib.mkForce false;

      # NTS only servers
      networking.timeServers = lib.mkForce [
        "time.ysun.co"
        "time.cloudflare.com"
        "virginia.time.system76.com"
        "ohio.time.system76.com"
        "oregon.time.system76.com"
        "paris.time.system76.com"
        "brazil.time.system76.com"
        "ntppool1.time.nl"
        "ntppool2.time.nl"
      ];

      services.ntpd-rs = {
        enable = lib.mkForce true;

        # all above servers are NTS capable
        # setting this to true will disable NTS
        useNetworkingTimeServers = lib.mkForce false;

        # client mode:
        # maybe add server capability in the future
        # once figure out how to setup anycast
        settings.source = (
          lib.map
            (s: {
              mode = "nts";
              address = s;
              ntp-version = "auto";
            })
            config.networking.timeServers
        );

        metrics.enable = config.services.prometheus.enable;
        settings.observability.metrics-exporter-listen = "${bind}:${lib.toString port}";
      };

      services.prometheus.scrapeConfigs = lib.mkIf config.services.prometheus.enable [{
        job_name = "prometheus-ntpdrs-exporter";
        static_configs = [{ targets = [ "${bind}:${lib.toString port}" ]; }];
      }];
    }
    (lib.mkIf serverConfig.enable {

      security.acme.certs.${serverConfig.domain} = {
        domain = serverConfig.domain;
        group = "ntpd-rs";
        reloadServices = [ "ntpd-rs.service" ];
      };

      networking.firewall = {
        # NTS-KE
        allowedTCPPorts = [ 4460 ];
        # NTP
        allowedUDPPorts = [ 123 ];
      };

      # server mode:
      # ntp, nts, and keyset config for nts
      services.ntpd-rs.settings = {
        server = [{
          listen = "[::]:123";
          accept-ntp-versions = serverConfig.acceptedVersions;
        }];
        nts-ke-server = [{
          listen = "[::]:4460";
          accept-ntp-versions = serverConfig.acceptedVersions;
          private-key-path = serverConfig.cert.key;
          certificate-chain-path = serverConfig.cert.fullchain;
        }];
        keyset.key-storage-path = "/var/lib/ntpd-rs/keyset";
      };

      # for storing keysets
      systemd.services.ntpd-rs.serviceConfig = {
        StateDirectory = "ntpd-rs";
        StateDirectoryMode = "0750";
      };
    })
  ];
}
