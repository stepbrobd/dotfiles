{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.arpa_ip6_2_6_0_2_f_5_9_0_0 = mkZone {
    name = "0.0.9.5.f.2.0.6.2.ip6.arpa";
  };
}
