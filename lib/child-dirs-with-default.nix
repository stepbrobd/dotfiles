/* @ts: import type { Lib } from "./type.nix.d.ts"; */
# @ts: { lib: Lib }
{ lib }:

# @ts: (dir: string | Path) => string[]
dir:

let
  inherit (lib)
    attrNames
    filter
    pathExists
    readDir
    ;

  entries = readDir dir;
in
filter
  (
    name:
    entries.${name} == "directory"
      && pathExists (dir + "/${name}/default.nix")
  )
  (attrNames entries)
