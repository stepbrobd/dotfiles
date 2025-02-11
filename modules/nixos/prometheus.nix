{ config, ... }:

{
  services.prometheus = {
    enable = true;
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

  services.caddy = {
    enable = true;
    virtualHosts."otel.${config.networking.fqdn}".extraConfig = ''
      import common
      handle_path /prometheus/* {
        reverse_proxy  ${with config.services.prometheus; toString listenAddress + ":" + toString port}
      }
    '';
  };
}
