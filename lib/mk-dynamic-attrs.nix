{ lib }:

# mkDynamicAttrs args
{ dir, fun }:

let
  inherit (lib) genAttrs;
  inherit (builtins) attrNames readDir;
in
genAttrs (attrNames (readDir dir)) (fun)
