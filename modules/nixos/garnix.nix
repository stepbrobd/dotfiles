{ inputs, lib, ... }:

{ config, ... }:

{
  imports = with inputs; [
    garnix.nixosModules.garnix
  ];

  sops = {
    age = {
      keyFile = lib.mkForce "/var/garnix/keys/repo-key";
      sshKeyPaths = lib.mkForce [ ];
    };
    gnupg = {
      home = lib.mkForce null;
      sshKeyPaths = lib.mkForce [ ];
    };
  };

  # https://garnix.io/docs/hosting/branch
  boot.loader.grub.device = "/dev/sda";
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  garnix.server = {
    enable = true;
    persistence = {
      enable = true;
      name = config.networking.hostName;
    };
  };

  networking.useNetworkd = lib.mkForce false;
  security.sudo.execWheelOnly = lib.mkOverride 49 true;
  security.sudo.extraRules = lib.mkOverride 49 [
    {
      users = [ "root" ];
      commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
    }
    {
      groups = [ "wheel" ];
      commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
    }
  ];
}
