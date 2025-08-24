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
  resource.tailscale_dns_preferences.preferences.magic_dns = true;

  resource.tailscale_dns_nameservers.nameservers.nameservers = [
    # NextDNS
    "2a07:a8c0::d8:664a"
    "2a07:a8c1::d8:664a"
    # still NextDNS but
    # only work with linked IP
    # "45.90.28.217"
    # "45.90.30.217"
  ];

  resource.tailscale_dns_search_paths.search_paths.search_paths = [
    # default, and added by default
    # ''''${data.sops_file.secrets.data["tailscale.tailnet_name"]}''
    "internal.center" # rebind to cloudflare
  ];

  # cloudflare interop
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
