{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban nftables tailscale time vxlan ];
  # services.prometheus.enable = true;
}
