{ lib, ... }:

{ config, options, pkgs, ... }:

let
  inherit (lib) forEach mkIf mkMerge mkOption optionalAttrs types;

  cfg = config.nix.nixbuild;

  nixbuildDomain = "eu.nixbuild.net";
  nixbuildKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
  nixbuildPlatforms = [ "x86_64-linux" "aarch64-linux" ];
  nixbuildFeatures = [ "big-parallel" "benchmark" "kvm" "nixos-test" ];
  nixbuildSSH = ''
    Host eu.nixbuild.net
      PubkeyAcceptedKeyTypes ssh-ed25519
      ServerAliveInterval 60
      IPQoS throughput
      IdentityFile /etc/ssh/ssh_host_ed25519_key
  '';
in
{
  options.nix.nixbuild = {
    enable = mkOption {
      default = false;
      description = "Whether to use nixbuild.net for distributed builds";
      example = true;
      type = types.bool;
    };

    systems = mkOption {
      type = with types; listOf str;
      default = nixbuildPlatforms;
      example = nixbuildPlatforms;
      description = "https://docs.nixbuild.net/getting-started/index.html#quick-nixos-configuration";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nix = {
        distributedBuilds = true;
        buildMachines = forEach cfg.systems (system: {
          inherit system;
          hostName = nixbuildDomain;
          maxJobs = 100;
          supportedFeatures = nixbuildFeatures;
        });

        settings.extra-substituters = [ "ssh://eu.nixbuild.net" ];
        settings.trusted-public-keys = [ "nixbuild.net/CQ9XPX-1:8WFF5qINzG2FrrvIePqdH+XraKME30g3+Es3aCWBw24=" ];
      };
    }

    {
      programs.ssh.knownHosts.nixbuild = {
        hostNames = [ nixbuildDomain ];
        publicKey = nixbuildKey;
      };
    }

    (mkIf pkgs.stdenv.isLinux (optionalAttrs (options?programs.ssh.extraConfig) {
      programs.ssh.extraConfig = nixbuildSSH;
    }))

    (mkIf pkgs.stdenv.isDarwin {
      environment.etc."ssh/ssh_config.d/nixbuild".text = nixbuildSSH;
    })

    {
      # https://github.com/ngi-nix/ngipkgs/blob/main/maintainers/nixbuild.nix#L56C1-L62C5
      environment.systemPackages = [
        (pkgs.writeShellApplication {
          name = "nixbuild";
          runtimeInputs = with pkgs; [ rlwrap ];
          text = "rlwrap ssh eu.nixbuild.net shell";
        })
      ];
    }
  ]);
}
