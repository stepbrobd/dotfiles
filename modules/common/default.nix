# nixpkgs + nix-darwin options

{ pkgs, ... }:

{
  imports = [
    ./nextdns.nix
    ./nix.nix
    ./nixpkgs.nix
    ./tailscale.nix
  ];

  environment.systemPackages = with pkgs; [ alacritty.terminfo ];
}
