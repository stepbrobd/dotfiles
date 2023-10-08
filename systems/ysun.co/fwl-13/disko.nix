{
  disko.devices.disk.nvme0n1 = {
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
        NixOS = {
          start = "512MiB";
          end = "-64GiB";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        Swap = {
          start = "-64GiB";
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
}
