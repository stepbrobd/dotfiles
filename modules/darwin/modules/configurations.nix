{ config, lib, pkgs, ... }: {
  config = {
    nix = {
      settings = {
        trusted-users = [
          "root"
          "StepBroBD"
        ];
        substituters = [
          "https://stepbrobd.cachix.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-update.cachix.org"
          "https://devenv.cachix.org"
        ];
        trusted-public-keys = [
          "stepbrobd.cachix.org-1:Aa5jdkPVrCOvzaLTC0kVP5PYQ5BtNnLg1tG1Qa/QuE4="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];
      };
      extraOptions = ''
        experimental-features = ca-derivations flakes impure-derivations nix-command
        auto-optimise-store = true
        keep-derivations = true
        keep-outputs = true
        keep-failed = false
        keep-going = true
      '';
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = true;
        allowUnsupportedSystem = true;
      };
    };

    system = {
      defaults = {
        NSGlobalDomain = {
          AppleICUForce24HourTime = true;
          AppleInterfaceStyle = "Dark";
          AppleInterfaceStyleSwitchesAutomatically = false;
          AppleMeasurementUnits = "Centimeters";
          AppleMetricUnits = 1;
          ApplePressAndHoldEnabled = false;
          AppleTemperatureUnit = "Celsius";
          "com.apple.mouse.tapBehavior" = 1;
        };
      };
    };

    security = {
      pam.enableSudoTouchIdAuth = true;
    };

    services = {
      nix-daemon.enable = true;
    };

    programs = {
      zsh.enable = true;
      nix-index.enable = true;
    };
  };
}
