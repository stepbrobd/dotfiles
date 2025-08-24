{ lib, ... }:

{ ... }:

let
  inherit (lib.terranix) mkDevices;
in
{
  data.tailscale_device = mkDevices [
    # server, router
    "butte"
    "highline"
    "kongo"
    "toompea"
    # server
    "halti"
    "isere"
    "lagern"
    "odake"
    "walberla"
    # golink
    "go"
    # untagged
    "framework"
    "ipad"
    "iphone"
    "macbook"
    "vision"
    "xps"
  ];
}
