{ inputs, lib, ... }:

{ config, ... }:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.services.attic;
in
{
  options.services.attic = {
    enable = mkOption {
      default = false;
      description = "Whether to enable attic service";
      example = true;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    age.secrets.attic = {
      file = "${inputs.self.outPath}/secrets/attic.age";
      owner = config.services.atticd.user;
      group = config.services.atticd.group;
    };

    services.atticd = {
      inherit (cfg) enable;

      environmentFile = config.age.secrets.attic.path;

      settings = cfg.settings // {
        compression.type = "zstd";

        chunking = {
          min-size = 16 * 1024;
          avg-size = 64 * 1024;
          max-size = 256 * 1024;
          nar-size-threshold = 64 * 1024;
        };

        garbage-collection = {
          interval = "24 hours";
          default-retention-period = "12 months";
        };

        storage = {
          type = "s3";
          region = "auto";
          bucket = "cache";
          endpoint = "https://6ff6fca6d9ffe9c77dd15a9095076b3b.r2.cloudflarestorage.com";
        };
      };
    };
  };
}
