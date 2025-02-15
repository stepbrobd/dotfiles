{ lib, ... }:

{ config, ... }:

let
  inherit (lib) /* mkIf */ toString;

  cfg = config.services.prometheus;
in
{
  config = /* mkIf cfg.enable */ {
    services.prometheus = {
      enable = true;
      globalConfig.scrape_interval = "30s";
      listenAddress = "127.0.0.1";
      port = 9090;

      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          listenAddress = "127.0.0.1";
          port = 9100;
        };
      };

      scrapeConfigs = [
        {
          job_name = "prometheus-node-exporter";
          static_configs = [
            { targets = [ "${with cfg.exporters.node; toString listenAddress + ":" + toString port}" ]; }
          ];
        }
      ];

      # alertmanagers = [{ static_configs = [{ targets = [ "${with cfg.alertmanager; toString listenAddress + ":" + toString port}" ]; }]; }];
      # alertmanager = {
      #   enable = true;
      #   listenAddress = "127.0.0.1";
      #   port = 9093;
      #   configuration = {
      #     global = { };
      #     route = {
      #       receiver = "ignore";
      #       group_wait = "30s";
      #       group_interval = "5m";
      #       repeat_interval = "24h";
      #       group_by = [ "alertname" ];
      #       routes = [ ];
      #     };
      #     receivers = [{ name = "ignore"; }];
      #   };
      # };
    };

    services.loki = {
      enable = true;
      extraFlags = [ "-print-config-stderr" ];

      configuration = {
        analytics.reporting_enabled = false;
        auth_enabled = false;
        # ruler.alertmanager_url = with cfg.alertmanager; "http://${listenAddress}:${toString port}";

        server = {
          http_listen_address = "127.0.0.1";
          http_listen_port = 3100;
          grpc_listen_port = 0;
        };

        ingester = {
          lifecycler = {
            address = "127.0.0.1";
            ring = {
              kvstore.store = "inmemory";
              replication_factor = 1;
            };
          };
          chunk_idle_period = "1h";
          max_chunk_age = "1h";
          chunk_target_size = 999999;
          chunk_retain_period = "30s";
        };

        schema_config.configs = [{
          from = "2024-04-01";
          object_store = "filesystem";
          store = "tsdb";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }];

        storage_config = with config.services.loki; {
          filesystem.directory = "${dataDir}/chunks";
          tsdb_shipper = {
            active_index_directory = "${dataDir}/tsdb-index";
            cache_location = "${dataDir}/tsdb-cache";
            cache_ttl = "24h";
          };
        };

        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };

        table_manager = {
          retention_deletes_enabled = false;
          retention_period = "0s";
        };

        compactor = {
          working_directory = config.services.loki.dataDir;
          compactor_ring.kvstore.store = "inmemory";
        };
      };
    };

    services.geoipupdate.enable = true;

    services.promtail = {
      enable = true;

      configuration = {
        server = {
          http_listen_address = "127.0.0.1";
          http_listen_port = 3180;
          grpc_listen_port = 0;
        };

        positions = {
          filename = "/tmp/positions.yaml";
        };

        clients = [{ url = with config.services.loki.configuration.server; "http://${http_listen_address}:${toString http_listen_port}/loki/api/v1/push"; }];

        scrape_configs = [{
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = config.networking.hostName;
            };
          };
          pipeline_stages = [{
            match = {
              selector = ''{unit="fail2ban.service"}'';
              stages = [
                { regex.expression = ''(?P<ip>(?:(?:25[0-5]|2[0-4]\d|[01]?\d?\d)(?:\.(?:25[0-5]|2[0-4]\d|[01]?\d?\d)){3})|(?:(?:[A-Fa-f0-9]{1,4}:){7}[A-Fa-f0-9]{1,4}|(?:[A-Fa-f0-9]{1,4}:){1,7}:|:(?::[A-Fa-f0-9]{1,4}){1,7}))\b.*''; }
                {
                  geoip = {
                    source = "ip";
                    db_type = "city";
                    db = "${config.services.geoipupdate.settings.DatabaseDirectory}/GeoLite2-City.mmdb";
                  };
                }
              ];
            };
          }];
          relabel_configs = [{
            source_labels = [ "__journal__systemd_unit" ];
            target_label = "unit";
          }];
        }];
      };
    };

    services.caddy = {
      enable = true;
      virtualHosts."otel.${config.networking.fqdn}".extraConfig = ''
        import common
        @blocked not remote_ip ${lib.blueprint.hosts.halti.ipv4}
        respond @blocked "Forbidden" 403

        handle_path /prometheus/* {
          respond @blocked "Forbidden" 403
          reverse_proxy  ${with cfg; toString listenAddress + ":" + toString port}
        }

        handle_path /loki/* {
          respond @blocked "Forbidden" 403
          reverse_proxy  ${with config.services.loki.configuration.server; http_listen_address + ":" + toString http_listen_port}
        }
      '';
    };
  };
}
