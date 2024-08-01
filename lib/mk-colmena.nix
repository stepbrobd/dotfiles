{ lib }:

let
  inherit (lib) genHostModules version versions;
in
{ inputs
, os
, platform
, stateVersion ? (versions.majorMinor version)
, hosts ? [ ] # [ "server1" "server2" ]
, users ? { } # { "username" -> [ module ] }
, modules ? [ ] # nixos/darwin modules
}:

let
  specialArgs = { inherit lib inputs; };
in
{
  meta = {
    inherit specialArgs;
    nixpkgs = import inputs.nixpkgs { system = platform; };
  };
} // lib.genAttrs hosts (host: {
  imports =
    let
      entrypoint = "${inputs.self}/hosts/server/${host}";
    in
    genHostModules {
      inherit inputs os platform stateVersion entrypoint users modules specialArgs;
    };
})
