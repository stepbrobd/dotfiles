{ lib, ... }:

{ config, ... }:

let
  bind = "127.0.0.1";
  port = 9975;
in
{
  services.timesyncd.enable = lib.mkForce false;

  # NTS only servers
  networking.timeServers = lib.mkForce [
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

    # client mode only
    # maybe add server capability in the future
    # once figure out how to setup anycast
    settings.source = (
      lib.map
        (s: {
          mode = "nts";
          address = s;
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
