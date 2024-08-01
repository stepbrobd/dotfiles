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
}:

let
  specialArgs = { inherit lib inputs; };
in
lib."${os}System" {
  inherit specialArgs;

  modules = genHostModules {
    inherit inputs os platform stateVersion entrypoint users modules specialArgs;
  };
}
