{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban nftables mglru tailscale time vxlan ];

  services.bpftune.enable = true;

  # services.prometheus.enable = true;
}
