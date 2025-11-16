{ config, pkgs, ... }:

{
  services.tailscale = {
    openFirewall = true;
    permitCertUid =
      if config.services.caddy.enable
      then config.services.caddy.user
      else null;
  };

  # in case nftables is used
  systemd.services.tailscaled.environment.TS_DEBUG_FIREWALL_MODE = config.networking.firewall.package.pname;

  # scrape tailscale metrics
  services.prometheus.scrapeConfigs = pkgs.lib.mkIf config.services.prometheus.enable [{
    job_name = "prometheus-tailscale-exporter";
    static_configs = [{ targets = [ "100.100.100.100:80" ]; }];
    metrics_path = "/metrics";
  }];
  # must set this flag or cant scrape
  services.tailscale.extraSetFlags = pkgs.lib.mkIf config.services.prometheus.enable [ "--webclient" ];
} // (
  let
    # https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes
    script = ''
      #!${pkgs.runtimeShell}

      export PATH=${pkgs.lib.makeBinPath (with pkgs; [ coreutils ethtool iproute2 ])}

      ethtool -K "$(ip -o route get 1.1.1.1 | cut -f 5 -d ' ')" rx-udp-gro-forwarding on rx-gro-list off
    '';
  in
  {
    networking.networkmanager.dispatcherScripts = [{
      type = "basic";
      source = pkgs.writeText "50-tailscale" script;
    }];

    services.networkd-dispatcher = {
      enable = !config.networking.networkmanager.enable;
      rules."50-tailscale" = {
        onState = [ "routable" ];
        inherit script;
      };
    };
  }
)
