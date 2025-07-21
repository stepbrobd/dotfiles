{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban nftables mglru tailscale time vxlan ];
  # services.prometheus.enable = true;
}
