{ lib, ... }:

{ config, pkgs, ... }:

{
  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
    permitCertUid =
      if config.services.caddy.enable
      then config.services.caddy.user
      else null;
  };

  # in case nftables is used
  systemd.services.tailscaled.environment.TS_DEBUG_FIREWALL_MODE = config.networking.firewall.package.pname;

  # https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes
  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = [ "routable" ];
      script = ''
        #!${pkgs.runtimeShell}

        export PATH=$PATH:${lib.makeBinPath (with pkgs; [ coreutils ethtool iproute2 ])}

        ethtool -K "$(ip -o route get 1.1.1.1 | cut -f 5 -d ' ')" rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  # scrape tailscale metrics
  services.prometheus.scrapeConfigs = pkgs.lib.mkIf config.services.prometheus.enable [{
    job_name = "prometheus-tailscale-exporter";
    static_configs = [{ targets = [ "100.100.100.100:80" ]; }];
    metrics_path = "/metrics";
  }];
  # must set this flag or cant scrape
  services.tailscale.extraSetFlags = pkgs.lib.mkIf config.services.prometheus.enable [ "--webclient" ];
}
