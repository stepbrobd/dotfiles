/* @ts: import type { Lib } from "./type.nix.d.ts"; */
# @ts: { lib: Lib }
{ lib }:

# @ts: (hostName: string) => (tag: string) => boolean
hostName: tag:
lib.elem tag (lib.blueprint.hosts.${hostName}.tags or [ ])
