{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.fr_grenug = mkZone {
    name = "grenug.fr";
  };
}
