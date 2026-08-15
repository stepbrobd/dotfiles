{ lib }:

# mkDynamicAttrs args
{ dir, fun }:

let
  inherit (lib) attrNames filter genAttrs readDir;

  entries = readDir dir;

  # filter stray files (readme.md, .DS_Store, etc.)
  dirs = filter (name: entries.${name} == "directory") (attrNames entries);
in
genAttrs dirs fun
