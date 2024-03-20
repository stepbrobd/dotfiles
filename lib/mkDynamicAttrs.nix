# haumea args
{ inputs, outputs }:

# mkDynamicAttrs args
{ dir, fun }:

let
  inherit (builtins) readDir;
  inherit (inputs.nixpkgs.lib) genAttrs attrNames;
in
genAttrs (attrNames (readDir dir)) (fun)
