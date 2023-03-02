{ inputs, ... }@flakeContext:
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
        auto-optimise-store = true;
      };
    };
    nixpkgs = {
      config = {
        allowUnfree = true;
        allowBroken = true;
        allowUnsupportedSystem = false;
      };
    };
    security = {
      pam = {
        enableSudoTouchIdAuth = true;
      };
    };
    services = {
      nix-daemon = {
        enable = true;
      };
    };
  };
}
