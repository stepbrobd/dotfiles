{ lib }:

# https://stackoverflow.com/a/54505212/17129151
let
  inherit (lib) all concatLists head isAttrs isList last tail unique zipAttrsWith;

  f = zipAttrsWith (_: values:
    if tail values == [ ]
    then head values
    else if all isList values
    then unique (concatLists values)
    else if all isAttrs values
    then f values
    else last values
  );
in
f
