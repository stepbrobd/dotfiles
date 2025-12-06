{ lib }:

let
  inherit (lib) genUserModules mkDefault;
in
{ inputs
, os
, platform
, entrypoint # file path
, users ? { } # { "username" -> [ module ] }
, modules ? [ ] # nixos/darwin modules
, specialArgs ? { }
}:

[
  entrypoint
  # no need to re-evaluate overlay as its already been applied by autopilot
  # { nixpkgs = { inherit (inputs.self.autopilot.nixpkgs) overlays; }; }
  inputs.sops."${os}Modules".sops
  { sops.defaultSopsFile = ./secrets.yaml; }
  { nixpkgs.hostPlatform = mkDefault platform; }
] ++ (genUserModules {
  inherit inputs os specialArgs users;
}) ++ modules
