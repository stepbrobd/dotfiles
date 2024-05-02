# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

let
  inherit (lib) forEach mkEnableOption mkIf mkOption types;

  cfg = config.services.nixbuild;
in
{
  options.services.nixbuild = {
    enable = mkEnableOption "nixbuild";

    systems = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
      description = "https://docs.nixbuild.net/getting-started/index.html#quick-nixos-configuration";
    };
  };

  config = mkIf cfg.enable
    {
      nix = {
        distributedBuilds = true;
        buildMachines = forEach cfg.systems (system: {
          inherit system;
          hostName = "eu.nixbuild.net";
          maxJobs = 100;
          supportedFeatures = [ "benchmark" "big-parallel" ];
        });
      };

      programs.ssh.knownHosts.nixbuild = {
        hostNames = [ "eu.nixbuild.net" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
      };

      # https://github.com/ngi-nix/ngipkgs/blob/main/maintainers/nixbuild.nix#L56C1-L62C5
      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "nixbuild";
          runtimeInputs = with pkgs; [ rlwrap ];
          text = "rlwrap ssh eu.nixbuild.net shell";
        })
      ];
    };
}
