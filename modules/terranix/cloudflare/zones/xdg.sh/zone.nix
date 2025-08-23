{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.sh_xdg = mkZone {
    name = "xdg.sh";
  };
}
