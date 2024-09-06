{ lib }:

# https://stackoverflow.com/a/54505212/17129151
let
  inherit (lib) all concatLists head isAttrs isList last tail unique zipAttrsWith;
in
attrList:
let
  f = attrPath: zipAttrsWith (n: values:
    if tail values == [ ]
    then head values
    else if all isList values
    then unique (concatLists values)
    else if all isAttrs values
    then f (attrPath ++ [ n ]) values
    else last values
  );
in
f [ ] attrList
