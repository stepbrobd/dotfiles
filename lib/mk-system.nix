{ lib }:

let
  inherit (lib) genHostModules version versions;
in
{ inputs
, os
, platform
, stateVersion ? (versions.majorMinor version)
, entrypoint # file path
, users ? { } # { "username" -> [ module ] }
, modules ? [ ] # nixos/darwin modules
, specialArgs ? { inherit lib inputs; }
}:

let
  system = platform;
in
lib."${os}System" {
  inherit specialArgs system;

  modules = genHostModules {
    inherit inputs os platform stateVersion entrypoint users modules specialArgs;
  };
}
