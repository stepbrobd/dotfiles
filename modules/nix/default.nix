# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  nix = {
    package = pkgs.nixVersions.unstable;

    gc = {
      automatic = true;
      options = "--delete-older-than 365d";
    };

    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      warn-dirty = false;

      trusted-users = [
        "root"
        "ysun"
      ];

      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.ngi0.nixos.org"
        "https://stepbrobd.cachix.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-update.cachix.org"
      ];

      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        "stepbrobd.cachix.org-1:Aa5jdkPVrCOvzaLTC0kVP5PYQ5BtNnLg1tG1Qa/QuE4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-update.cachix.org-1:6y6Z2JdoL3APdu6/+Iy8eZX2ajf09e4EE9SnxSML1W8="
      ];

      experimental-features = [
        "auto-allocate-uids"
        "ca-derivations"
        "cgroups"
        "flakes"
        "impure-derivations"
        "nix-command"
        "repl-flake"
      ];
    };

    extraOptions = ''
      keep-build-log = true
      keep-derivations = true
      keep-env-derivations = true
      keep-failed = true
      keep-going = true
      keep-outputs = true
    '';
  };
}
