# haumea args
{ lib
, rev
, inputs
, outputs
}:

# mkDynamicAttrs args
{ dir
, fun
}:

lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (fun)
