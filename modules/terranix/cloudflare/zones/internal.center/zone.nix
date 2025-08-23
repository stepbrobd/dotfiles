{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.center_internal = mkZone {
    name = "internal.center";
  };
}
