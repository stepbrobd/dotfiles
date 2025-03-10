{ config, pkgs, ... }:

{
  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
  };

  # allow caddy to use tailscale certs
  systemd.services.tailscaled.environment.TS_PERMIT_CERT_UID = config.services.caddy.user;

  # https://tailscale.com/kb/1320/performance-best-practices#linux-optimizations-for-subnet-routers-and-exit-nodes
  networking.localCommands = ''
    NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 1.1.1.1 | ${pkgs.coreutils}/bin/cut -f 5 -d " ")
    ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off
  '';
}
