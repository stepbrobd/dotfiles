{
  disko.devices = {
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "ef00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          SWAP = {
            type = "8200";
            size = "96G";
            content = {
              type = "swap";
              randomEncryption = true;
              resumeDevice = true;
            };
          };
          ROOT = {
            type = "8300";
            size = "100%";
            content = {
              type = "zfs";
              pool = "local";
            };
          };
        };
      };
    };
    zpool.local = {
      type = "zpool";
      options = {
        ashift = "13";
        autotrim = "on";
      };
      rootFsOptions = {
        atime = "off";
        compression = "lz4";
        xattr = "sa";
        mountpoint = "none";
        canmount = "off";
        acltype = "posixacl";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
        normalization = "formD";
        "com.sun:auto-snapshot" = "false";
      };
      postCreateHook = ''
        zfs snapshot -r local@blank
        zfs set keylocation="prompt" "local";
      '';
      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
        };
      };
    };
  };
}
