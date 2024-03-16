# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./activation.nix
    ./fonts.nix
    ./homebrew.nix
    ./sshd.nix
    ./system.nix
    ./tailscale.nix
  ];
}
