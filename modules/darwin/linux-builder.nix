{ pkgs, ... }:

{
  nix.linux-builder = {
    enable = false;

    ephemeral = true;
    maxJobs = 8;
    speedFactor = 2;

    package = pkgs.darwin.linux-builder-vz;
    systems = [ "aarch64-linux" "x86_64-linux" ];
    supportedFeatures = [ "benchmark" "big-parallel" ];

    config = {
      virtualisation = {
        cores = 8;
        darwin-builder = {
          diskSize = 50 * 1024;
          memorySize = 8 * 1024;
        };
      };
    };
  };
}
