{ lib }:

let
  inherit (lib) genHostModules;
in
{ inputs
, os
, platform
, hosts ? [ ] # [ "server1" "server2" ]
, users ? { } # { "username" -> [ module ] }
, modules ? [ ] # nixos/darwin modules
, nixpkgs ? { }
, specialArgs ? { }
}:

{
  meta = {
    inherit nixpkgs specialArgs;
  };
} // lib.genAttrs hosts (host: {
  imports =
    let
      entrypoint = "${inputs.self}/hosts/server/${host}";
    in
    genHostModules
      {
        inherit inputs os platform entrypoint users modules specialArgs;
      } ++ [
      (
        { config, ... }:
        {
          deployment = {
            targetUser = null;
            targetHost = "${config.networking.hostName}.tail650e82.ts.net";
          };
        }
      )
    ];
})
