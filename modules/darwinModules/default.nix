{ inputs, ... }@context:
{ config, lib, pkgs, ... }: {
  config = {
    nix = {
      extraOptions = ''
        experimental-features = ca-derivations flakes impure-derivations nix-command
        auto-optimise-store = true
        keep-derivations = true
        keep-outputs = true
        keep-failed = false
        keep-going = true
      '';
      settings = {
        substituters = [
          "https://stepbrobd.cachix.org"
          "https://nix-community.cachix.org"
          "https://nixpkgs-update.cachix.org"
        ];
        trusted-public-keys = [
          "stepbrobd.cachix.org-1:Aa5jdkPVrCOvzaLTC0kVP5PYQ5BtNnLg1tG1Qa/QuE4="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
        ];
        trusted-users = [
          "root"
          "StepBroBD"
        ];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;
      };
    };

    programs = {
      zsh.enable = true;
    };

    security = {
      pam.enableSudoTouchIdAuth = true;
    };

    services = {
      nix-daemon.enable = true;
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
  };
}
