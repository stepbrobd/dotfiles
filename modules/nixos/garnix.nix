{ inputs, ... }:

{ config, ... }:

{
  imports = with inputs; [
    garnix.nixosModules.garnix
    sops.nixosModules.sops
  ];

  sops.age.sshKeyPaths = [ "/var/garnix/keys/repo-key" ];

  # https://garnix.io/docs/hosting/branch
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  garnix.server.persistence = {
    enable = true;
    name = config.networking.fqdn;
  };
}
