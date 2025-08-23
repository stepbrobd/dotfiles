{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.phd_deeznuts = mkZone {
    name = "deeznuts.phd";
  };
}
