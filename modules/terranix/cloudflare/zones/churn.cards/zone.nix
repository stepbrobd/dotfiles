{ lib, ... }:

let
  inherit (lib.terranix) mkZone;
in
{
  resource.cloudflare_zone.cards_churn = mkZone {
    name = "churn.cards";
  };
}
