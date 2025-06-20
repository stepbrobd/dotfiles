{ lib }:

let
  inherit (lib) genUserModules hasSuffix mkDefault version versions;
in
{ inputs
, os
, platform
, stateVersion ? (versions.majorMinor version)
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
  { system.stateVersion = if hasSuffix "darwin" platform then 5 else stateVersion; }
] ++ (genUserModules {
  inherit inputs os stateVersion specialArgs users;
}) ++ modules
