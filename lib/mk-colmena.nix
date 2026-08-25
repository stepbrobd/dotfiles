/* @ts: import type { Lib } from "./type.nix.d.ts"; */
# @ts: { lib: Lib }
{ lib }:

let
  inherit (lib) assertMsg attrNames concatMap concatStringsSep count filter genAttrs genHostModules length map mapAttrs mergeAttrsList unique;
in
# @ts: { inputs: any; hosts: any[]; nixpkgs: any; nix_darwin: any; getSystem: (platform: string) => any; specialArgs: Record<string, any> }
{ inputs
, hosts ? [ ] # [ { os, platform, modules, users, names } ]
, nixpkgs # raw nixpkgs flake input
, nix-darwin ? null # nix-darwin flake input
, getSystem # platform -> perSystem attrset
, specialArgs ? { }
}:

let
  allNames = concatMap (group: group.names) hosts;

  # flatten groups into { host -> { os, platform, modules, users } }
  # a name in two groups would silently resolve last-group-wins, so reject it
  hostConfigs =
    assert assertMsg (length allNames == length (unique allNames))
      "mkColmena: duplicate host names across groups: ${concatStringsSep ", " (filter (n: count (x: x == n) allNames > 1) (unique allNames))}";
    mergeAttrsList (map
      (group: genAttrs group.names (_: {
        inherit (group) os platform modules users;
      }))
      hosts);

  allHostNames = attrNames hostConfigs;
in
{
  meta = {
    # only used for colmena bootstrapping (lib, eval-config.nix path);
    # each node's actual pkgs comes from nodeNixpkgs
    nixpkgs = import nixpkgs { system = "x86_64-linux"; };
    # for darwin deployment
    inherit nix-darwin;

    nodeNixpkgs = mapAttrs
      (_: cfg: (getSystem cfg.platform).allModuleArgs.pkgs)
      hostConfigs;

    inherit specialArgs;

    # no yolo ;)
    allowApplyAll = false;
  };
} // genAttrs allHostNames (host:
  let
    cfg = hostConfigs.${host};
    entrypoint = "${inputs.self}/hosts/${host}";
  in
  {
    # at hive node top-level so getNodeSystemType can detect it before evaluation
    deployment.systemType = cfg.os;
    # yolo
    deployment.allowLocalDeployment = true;

    imports =
      genHostModules
        {
          inherit inputs specialArgs entrypoint;
          inherit (cfg) os platform modules users;
        } ++ [
        (
          { config, ... }:
          {
            deployment =
              {
                targetUser = null;
                targetHost = "${config.networking.hostName}.${lib.blueprint.tailscale.tailnet}";

                # fix hanging issue
                sshOptions = [
                  "-o"
                  "ConnectTimeout=10"
                  "-o"
                  "ServerAliveCountMax=3"
                  "-o"
                  "ServerAliveInterval=10"
                  "-o"
                  "TCPKeepAlive=no"
                ];

                # inherit all the tags so its easier to filter
                tags = lib.blueprint.hosts.${config.networking.hostName}.tags or [ ];
              };
          }
        )
      ];
  })
