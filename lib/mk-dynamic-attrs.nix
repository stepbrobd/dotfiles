/* @ts: import type { Lib } from "./type.nix.d.ts"; */
# @ts: { lib: Lib }
{ lib }:

# mkDynamicAttrs args
# @ts: { dir: string | Path; fun: (name: string) => any }
{ dir, fun }:

let
  inherit (lib) attrNames filter genAttrs readDir;

  entries = readDir dir;

  # filter stray files (readme.md, .DS_Store, etc.)
  dirs = filter (name: entries.${name} == "directory") (attrNames entries);
in
genAttrs dirs fun
