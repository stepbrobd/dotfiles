{ config, ... }:

{
  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
  };

  # allow caddy to use tailscale certs
  systemd.services.tailscaled.environment.TS_PERMIT_CERT_UID = config.services.caddy.user;
}
