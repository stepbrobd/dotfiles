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
          deployment =
            let
              bp = lib.blueprint.hosts.${config.networking.hostName} or null;
            in
            {
              targetUser = null;
              targetHost = "${config.networking.hostName}.${lib.blueprint.tailscale.tailnet}";

              # inherit all the tags so its easier to filter
              tags = lib.unique (
                (if bp != null then bp.tags else [ ])
                ++ lib.optional (bp != null && bp ? platform) bp.platform
                ++ lib.optional (bp != null && bp ? provider) bp.provider
              );
            };
        }
      )
    ];
})
