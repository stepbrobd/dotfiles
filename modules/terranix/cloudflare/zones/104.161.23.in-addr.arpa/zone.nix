{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.arpa_in_addr_23_161_104 = mkZone {
    name = "104.161.23.in-addr.arpa";
  };
}
