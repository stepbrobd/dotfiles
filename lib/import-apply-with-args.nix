{ lib }:

modulePath: staticArgs:

# check the implementation of `importApply` in flake-parts and nixpkgs #230588 for details
let
  inherit (lib) all attrNames elem filterAttrs functionArgs intersectLists isFunction setDefaultModuleLocation;

  f = import modulePath;

  # names of arguments passed to `importApplyWithArgs`
  staticArgNames = attrNames staticArgs;

  # names of arguments used in the importing module
  # the module might not use arguments from `importApplyWithArgs`
  # the module is
  # 1. either a set or a function that returns a set
  # 2. if `importApplyWithArgs` is used, the module will either be a function that returns a set or a function of a function that returns a set
  # 3. staticArgs are applied only when the first pattern names one of them AND staticArgs can satisfy every non-defaulted pattern argument
  #    an idiomatic uncurried module (e.g. `{ config, lib, pkgs, ... }:`) falls through to the module system instead (use lib from specialArgs)
  # 4. a non-pattern lambda (`args: ...`) is probed with `f { }`, it must not compute on its arg before returning the inner function (or the set)
  moduleArgNames = if isFunction f then attrNames (functionArgs f) else [ ];

  # pattern arguments without a default, i.e. what a call must provide
  requiredArgNames = attrNames (filterAttrs (_: hasDefault: !hasDefault) (functionArgs f));

  argUsed =
    if !(isFunction f) then false # short circuit
    else if moduleArgNames == [ ] then isFunction (f { }) # non-pattern lambda (probe for the curried form)
    else
      intersectLists staticArgNames moduleArgNames != [ ] # pattern names a static arg (intent)
      && all (n: elem n staticArgNames) requiredArgNames; # and staticArgs alone can satisfy it
in
setDefaultModuleLocation modulePath (
  if argUsed
  then
    f staticArgs
  else
    f
)
