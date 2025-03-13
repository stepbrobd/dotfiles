{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban nftables tailscale ];
  # services.prometheus.enable = true;
}
