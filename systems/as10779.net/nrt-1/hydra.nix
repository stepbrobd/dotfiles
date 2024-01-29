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
    listenHost = "127.0.0.1";
    port = 10069;
    hydraURL = "https://hydra.nixolo.gy";
    minimumDiskFree = 5;
    minimumDiskFreeEvaluator = 5;
    notificationSender = "hydra@localhost";
    smtpHost = "localhost";
  };

  nix = {
    useSandbox = false;

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
