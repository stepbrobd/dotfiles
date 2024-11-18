{ inputs, ... }:

{
  # https://garnix.io/docs/hosting/secrets
  imports = [ inputs.agenix.nixosModules.age ];
  age.identityPaths = [ "/var/garnix/keys/repo-key" ];

  # https://garnix.io/docs/hosting/branch
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
