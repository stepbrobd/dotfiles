{ inputs, lib, ... }:

{ pkgs, ... }:

{
  # lower  than option default (1500)
  # higher than        default (1000)
  # need to do this since nixos for raspberry pi module set mkDefault
  # for the kernel with rpi firmware, and we'd want to keep that but override
  # the default for other linux machines, which is set by mkOptionDefault
  boot.kernelPackages = lib.mkOverride 1250 pkgs.linuxPackages_latest;

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

  boot.tmp.cleanOnBoot = true;

  users.mutableUsers = false;

  services.openssh = {
    enable = true;
    hostKeys = lib.mkForce [{ type = "ed25519"; path = "/etc/ssh/ssh_host_ed25519_key"; }];
    settings.PermitRootLogin = lib.mkForce "no";
    settings.KexAlgorithms = lib.mkForce [
      "mlkem768x25519-sha256"
      "sntrup761x25519-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    settings.Ciphers = lib.mkForce [ "chacha20-poly1305@openssh.com" ];
    settings.Macs = lib.mkForce [
      "hmac-sha2-256-etm@openssh.com"
      "hmac-sha2-512-etm@openssh.com"
    ];
  };

  systemd.services.network-local-commands = {
    before = lib.mkForce [ ];
    after = lib.mkForce [ "network-online.target" "systemd-networkd.service" ];
    wants = lib.mkForce [ "network-online.target" ];
    wantedBy = lib.mkForce [ "multi-user.target" ];
  };
}
