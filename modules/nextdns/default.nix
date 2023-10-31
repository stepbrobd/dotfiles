# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  services.nextdns = {
    enable = true;
    arguments = [ "-config" "d8664a" ];
  };
}
