{
  disko.devices.disk.nvme0n1 = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          start = "0";
          # end = "512M";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        ROOT = {
          start = "512M";
          # end = "-64G";
          end = "-64G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        SWAP = {
          start = "-64G";
          end = "100%";
          # size = "100%";
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
