{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.com_stepbrobd = mkZone {
    name = "stepbrobd.com";
  };
}
