{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban nftables mglru tailscale time vxlan ];

  services.bpftune.enable = true;

  # services.prometheus.enable = true;

  systemd.services.network-local-commands = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
