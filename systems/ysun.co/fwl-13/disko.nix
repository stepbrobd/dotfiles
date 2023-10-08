{
  disko.devices.disk.nvme0n1 = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        NixOS = {
          end = "-64G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        Swap = {
          size = "100%";
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
