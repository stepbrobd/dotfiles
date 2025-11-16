{ inputs, lib, ... }:

{
  imports = with inputs.self.nixosModules; [
    fail2ban
    mglru
    nftables
    tailscale
    time
    vxlan
  ];

  services.bpftune.enable = true;

  # services.prometheus.enable = true;

  systemd.services.network-local-commands = {
    before = lib.mkForce [ ];
    after = lib.mkForce [ "network-online.target" "systemd-networkd.service" ];
    wants = lib.mkForce [ "network-online.target" ];
    wantedBy = lib.mkForce [ "multi-user.target" ];
  };
}
