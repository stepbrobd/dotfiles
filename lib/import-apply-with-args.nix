{ lib }:

modulePath: staticArgs:

# check the implementation of `importApply` in flake-parts and nixpkgs #230588 for details
let
  inherit (lib) attrNames intersectLists isFunction length setDefaultModuleLocation;

  f = import modulePath;

  # names of the arguments passed to `importApplyWithArgs`
  staticArgNames = attrNames staticArgs;

  # names of the arguments used in the module
  # the module might not use arguments from `importApplyWithArgs`
  # i.e. either a set of a function that returns a set
  # if `importApplyWithArgs` is used
  # the module will be a function of set of function of function of a set
  # and the first attrset styled argument will match one of the names in `staticArg`
  moduleArgNames = if isFunction f then attrNames (__functionArgs f) else [ ];

  argUsed = length (intersectLists staticArgNames moduleArgNames) > 0;
in
setDefaultModuleLocation modulePath (
  if argUsed
  then
    f staticArgs
  else
    f
)
