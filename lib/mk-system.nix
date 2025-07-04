{ lib }:

let
  inherit (lib) genHostModules;
in
{ inputs
, os
, platform
, entrypoint # file path
, users ? { } # { "username" -> [ module ] }
, modules ? [ ] # nixos/darwin modules
, specialArgs ? { inherit lib inputs; }
}:

let
  system = platform;
in
lib."${os}System" {
  inherit specialArgs system lib;

  modules = genHostModules {
    inherit inputs os platform entrypoint users modules specialArgs;
  };
}
