{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban nftables tailscale time ];
  # services.prometheus.enable = true;
}
