{ modulesPath, lib, ... }:

{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];

  # TODO: remove after https://github.com/nixos/nixpkgs/pull/554254
  boot.extraModulePackages = lib.mkForce [ ];

  # AWS 1:1 NAT
  # public IPv4 (16.62.113.214) is not on ens5 (172.31.34.75)
  # null the local address so strongswan resolves source via routing table
  # the registry still advertises the public IP for peers to connect to
  networking.ranet.settings.endpoints = lib.map
    (ep: if ep.address_family == "ip4" then ep // { address = null; } else ep)
    lib.blueprint.hosts.lagern.ranet.endpoints;

  system.stateVersion = "25.05";
}
