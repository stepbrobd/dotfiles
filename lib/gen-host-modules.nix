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
  { nixpkgs.overlays = [ inputs.self.overlays.default ]; }
  inputs.sops."${os}Modules".sops
  { sops.defaultSopsFile = ./secrets.yaml; }
  { nixpkgs.hostPlatform = mkDefault platform; }
] ++ (genUserModules {
  inherit inputs os specialArgs users;
}) ++ modules
