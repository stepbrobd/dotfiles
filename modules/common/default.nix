# nixpkgs + nix-darwin options

{ pkgs, ... }:

{
  imports = [
    ./nextdns.nix
    ./nix.nix
    ./nixbuild.nix
    ./nixpkgs.nix
    ./tailscale.nix
  ];

  environment.systemPackages = with pkgs; [ alacritty.terminfo ];
}
