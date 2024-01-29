# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  services.hydra = {
    enable = true;

    useSubstitutes = true;
    buildMachinesFiles = [ ];

    minimumDiskFree = 5;
    minimumDiskFreeEvaluator = 5;

    hydraURL = "https://hydra.nixolo.gy";
    listenHost = "127.0.0.1";
    port = 10069;

    notificationSender = "hydra@localhost";
    smtpHost = "localhost";

    logo = ./logo.png;
    tracker = ''
      <script defer data-domain="hydra.nixolo.gy" src="https://stats.nixolo.gy/js/script.js"></script>
    '';
  };

  nix = {
    settings.sandbox = false;

    settings.allowed-uris = [
      "flake:"
      "path:"
      "github:"
      "gitlab:"
      "sourcehut:"
      "git+https:"
      "git+ssh:"
      "git+file:"
    ];

    buildMachines = [
      {
        hostName = "localhost";
        system = config.nixpkgs.hostPlatform.system;
        supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
        maxJobs = 8;
      }
    ];

    extraOptions = ''
      build-timeout = 86400  # 24 hours
    '';
  };
}