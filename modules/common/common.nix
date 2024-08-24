{ inputs, lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) mapAttrs mapAttrsToList mkForce optional;
in
{
  # enable nextdns and tailscale on all hosts
  services = {
    nextdns = {
      enable = true;
      arguments = [
        "-config"
        "d8664a"
      ];
    };

    tailscale.enable = true;
  };

  nix = {
    package = pkgs.nixVersions.stable;

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    registry = mkForce (mapAttrs (_: value: { flake = value; }) inputs);

    nixPath = mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      builders-use-substitutes = true;
      use-xdg-base-directories = true;
      warn-dirty = false;

      trusted-users = [ "root" ]
        ++ (optional pkgs.stdenv.isLinux "@wheel")
        ++ (optional pkgs.stdenv.isDarwin "@admin");

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
        "https://cosmic.cachix.org"
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
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
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

  # alacritty terminfo
  environment.systemPackages = with pkgs; [ alacritty.terminfo ];
}
