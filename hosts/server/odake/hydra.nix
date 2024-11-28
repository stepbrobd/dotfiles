{ config, lib, pkgs, ... }:

{
  services.caddy = {
    enable = true;

    virtualHosts."hydra.nixolo.gy".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';

    virtualHosts."hydra.ysun.co".extraConfig = ''
      import common
      reverse_proxy ${toString config.services.hydra.listenHost}:${toString config.services.hydra.port}
    '';
  };

  services.hydra = {
    enable = true;
    logo = ./logo.png;

    useSubstitutes = true;
    minimumDiskFree = 5;
    minimumDiskFreeEvaluator = 5;

    hydraURL = "https://hydra.nixolo.gy";
    listenHost = "127.0.0.1";
    port = 10069;
    notificationSender = "hydra@localhost";

    extraConfig = ''
      tracker = <script defer data-domain="hydra.ysun.co" src="https://stats.nixolo.gy/js/script.file-downloads.hash.outbound-links.js"></script>

      email_notification = 0

      <dynamicruncommand>
        enable = 1
      </dynamicruncommand>
    '';
  };

  nix = {
    settings.sandbox = false;

    settings.allowed-uris = [
      "flake:"
      "git+https:"
      "git+ssh:"
      "github:"
      "gitlab:"
      "https:"
      "path:"
      "sourcehut:"
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
