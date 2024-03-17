# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  services.tailscale.overrideLocalDns = true;
}
