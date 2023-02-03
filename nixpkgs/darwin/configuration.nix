{ pkgs, lib, ... }:

{
  nix.settings.substituters = [ "https://cache.nixos.org/" ];
  nix.settings.trusted-users = [ "@admin" ];
  nix.configureBuildUsers = true;

  nix.package = pkgs.nixUnstable;

  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

  nix.extraOptions = ''
    auto-optimise-store = true
    keep-derivations = true
    keep-outputs = true
    experimental-features = nix-command flakes
  ''
  +
  lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  environment.systemPackages = with pkgs; [
    zsh
    home-manager
  ];
  programs.zsh.enable = true;
}
