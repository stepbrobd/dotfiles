{ lib, ... }:

let
  inherit (lib.terranix) forZone tfRef;

  for_each = tfRef "{ for d in data.tailscale_devices.all.devices : d.hostname => d }";
  name = tfRef "each.value.hostname";
  proxied = false;
  ipv4 = tfRef "each.value.addresses[0]";
  ipv6 = tfRef "each.value.addresses[1]";
in
{
  resource.cloudflare_dns_record = forZone "internal.center" {
    center_internal_tailscale_v4 = {
      inherit for_each name proxied;
      type = "A";
      content = ipv4;
      comment = "Tailscale IPv4 - `tailscale whois ${ipv4}`";
    };
    center_internal_tailscale_v6 = {
      inherit for_each name proxied;
      type = "AAAA";
      content = ipv6;
      comment = "Tailscale IPv6 - `tailscale whois ${ipv6}`";
    };
  };
}
