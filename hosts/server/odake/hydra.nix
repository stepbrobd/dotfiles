{ config, lib, pkgs, ... }:

{
  services.hydra = {
    enable = true;
    logo = ./logo.png;

    useSubstitutes = true;
    buildMachinesFiles = [ ];
    minimumDiskFree = 5;
    minimumDiskFreeEvaluator = 5;

    hydraURL = "https://hydra.nixolo.gy";
    listenHost = "127.0.0.1";
    port = 10069;
    notificationSender = "hydra@nixolo.gy";

    extraConfig = ''
      email_notification = 1

      <dynamicruncommand>
        enable = 1
      </dynamicruncommand>
    '';
  };

  # possibly need to add msmtp?
  # https://nixos.wiki/wiki/Msmtp
  age.secrets.hydra-notify.file = ../../../secrets/hydra-notify.age;
  systemd.services =
    lib.mapAttrs
      (_name: _: {
        path = [ pkgs.msmtp ];
        serviceConfig.EnvironmentFile = config.age.secrets.hydra-notify.path;
      })
      (
        lib.genAttrs [
          "hydra-evaluator"
          "hydra-notify"
          "hydra-send-stats"
          "hydra-queue-runner"
          "hydra-server"
        ]
          { }
      );

  nix = {
    settings.sandbox = false;

    settings.allowed-uris = [
      "flake:"
      "path:"
      "github:"
      "git+https://github.com/"
      "git+ssh://github.com/"
      "gitlab:"
      "git+https://gitlab.com/"
      "git+ssh://gitlab.com/"
      "sourcehut:"
      "git+https://git.sr.ht/"
      "git+ssh://git.sr.ht/"
    ];

    buildMachines = [
      {
        hostName = "localhost";
        system = config.nixpkgs.hostPlatform.system;
        supportedFeatures = [
          "kvm"
          "nixos-test"
          "big-parallel"
          "benchmark"
        ];
        maxJobs = 8;
      }
    ];

    extraOptions = ''
      build-timeout = 86400  # 24 hours
    '';
  };
}
