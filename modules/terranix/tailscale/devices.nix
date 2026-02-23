{ lib, ... }:

{ ... }:

let
  inherit (lib.terranix) mkDevices;
in
{
  data.tailscale_devices.all = { };

  data.tailscale_device = mkDevices [
    # server, routee
    "isere"
    # server, router
    "butte"
    "highline"
    "kongo"
    "timah"
    "toompea"
    # server
    "halti"
    "lagern"
    "odake"
    "walberla"
    # aperture
    "aperture"
    # golink
    "go"
    # untagged
    "framework"
    "iphone"
    "macbook"
    "tv"
    "vision"
    "xps"
  ];
}
