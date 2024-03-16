# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  services.tailscale = {
    openFirewall = true;
    useRoutingFeatures = "both";
  };
}
