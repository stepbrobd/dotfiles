{ lib, ... }:

{ config, ... }:

let
  inherit (lib) mkIf toString;

  cfg = config.services.prometheus;
in
{
  config = mkIf cfg.enable {
    services.prometheus = {
      globalConfig.scrape_interval = "30s";

      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
        };
      };

      scrapeConfigs = [
        {
          job_name = "prometheus-node-exporter";
          static_configs = [
            { targets = [ "${with config.services.prometheus.exporters.node; toString listenAddress + ":" + toString port}" ]; }
          ];
        }
      ];
    };

    services.loki = {
      enable = true;
      extraFlags = [ "-print-config-stderr" ];

      configuration = {
        auth_enabled = false;

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
        handle_path /prometheus/* {
          reverse_proxy  ${with config.services.prometheus; toString listenAddress + ":" + toString port}
        }
        handle_path /loki/* {
          reverse_proxy  ${with config.services.loki.configuration.server; http_listen_address + ":" + toString http_listen_port}
        }
      '';
    };
  };
}
