{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.net_as10779 = mkZone {
    name = "as10779.net";
  };
}
