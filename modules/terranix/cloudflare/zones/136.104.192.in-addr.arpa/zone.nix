{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.arpa_in_addr_192_104_136 = mkZone {
    name = "136.104.192.in-addr.arpa";
  };
}
