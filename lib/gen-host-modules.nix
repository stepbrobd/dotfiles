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
  inputs.agenix."${os}Modules".age
  inputs.sops."${os}Modules".sops
  { nixpkgs.hostPlatform = mkDefault platform; }
  { system.stateVersion = if hasSuffix "darwin" platform then 4 else stateVersion; }
] ++ (genUserModules {
  inherit inputs os stateVersion specialArgs users;
}) ++ modules
