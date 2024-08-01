{ lib }:

let
  inherit (lib) genUserModules hasSuffix mkDefault version versions;
in
# mkSystem args
{ inputs
, os
, platform
, stateVersion ? (versions.majorMinor version)
, entrypoint # file path
, users ? { } # { "username" -> [ module ] }
, modules ? [ ] # nixos/darwin modules
}:

let
  specialArgs = { inherit lib inputs; };
in
lib."${os}System" {
  inherit specialArgs;

  modules = [
    entrypoint
    inputs.agenix."${os}Modules".age
    { nixpkgs.hostPlatform = mkDefault platform; }
    { system.stateVersion = if hasSuffix "darwin" platform then 4 else stateVersion; }
  ] ++ (genUserModules {
    inherit inputs os stateVersion specialArgs users;
  }) ++ modules;
}
