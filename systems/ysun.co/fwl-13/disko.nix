{
  disko.devices = {
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            start = "0";
            end = "512MiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          ROOT = {
            start = "512MiB";
            end = "-64G";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
          SWAP = {
            start = "-64G";
            end = "100%";
            content = {
              type = "swap";
              randomEncryption = true;
              resumeDevice = true;
            };
          };
        };
      };
    };
    zpool.zroot = {
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
        zfs snapshot -r zroot@blank
        zfs set keylocation="prompt" "zroot";
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
