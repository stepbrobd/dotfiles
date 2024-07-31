# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, inputs
, ...
}:

{
  nix = {
    package = pkgs.nixVersions.stable;

    gc = {
      automatic = true;
      options = "--delete-older-than 365d";
    };

    registry = lib.mkForce (lib.mapAttrs (_: value: { flake = value; }) inputs);

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      warn-dirty = false;

      trusted-users = [ "root" "@admin" "@wheel" ];

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        "cgroups"
        "flakes"
        "impure-derivations"
        "nix-command"
      ];

      extra-substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://nixpkgs-update.cachix.org"
        "https://colmena.cachix.org"
        "https://ngi.cachix.org"
        "https://stepbrobd.cachix.org"
        "https://cache.nixolo.gy"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        "ngi.cachix.org-1:n+CAL72ROC3qQuLxIHpV+Tw5t42WhXmMhprAGkRSrOw="
        "stepbrobd.cachix.org-1:Aa5jdkPVrCOvzaLTC0kVP5PYQ5BtNnLg1tG1Qa/QuE4="
        "cache.nixolo.gy:UDmjlw8J4sqDlBIPe5YnABPI1lkcJssN8niLozS2ltM="
      ];
    };

    extraOptions = ''
      allow-import-from-derivation = true
      keep-build-log = true
      keep-derivations = true
      keep-env-derivations = true
      keep-failed = true
      keep-going = true
      keep-outputs = true
    '';
  };
}
