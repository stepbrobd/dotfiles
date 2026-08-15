{ lib }:

{ dir
, currentFinal
, currentPrev
, inheritedArgs ? { }
}:

let
  inherit (lib)
    callPackageWith
    childDirsWithDefault
    importPackagesTree
    isAttrs
    isDerivation
    isFunction
    length
    makeScope
    mkDynamicAttrs
    pathExists
    tryEval
    ;

  # expose top-level package args (e.g. fetchgit) shadowed by scope args (e.g. mkDerivation) inherited args always win
  # lib, inputs, pkgsFinal/pkgsPrev and ancestor <scope>Final/<scope>Prev are reserved names that resolve to the flake-level values even if a scope exposes a same-named member
  callArgs = (inheritedArgs.pkgsFinal or currentFinal) // currentFinal // inheritedArgs;
in
mkDynamicAttrs {
  inherit dir;
  fun =
    name:
    let
      pkg = dir + "/${name}";
      hasDefaultNix = pathExists (pkg + "/default.nix");
      childScopeNames = if !hasDefaultNix then childDirsWithDefault pkg else [ ];
      hasChildScopes = length childScopeNames > 0;

      # lazy eval, only touch currentPrev when the local package path has no default.nix and guard alias throws with tryEval
      hasScopeAttr = !hasDefaultNix && currentPrev ? ${name};
      scopeEval =
        if hasScopeAttr then
          tryEval currentPrev.${name}
        else
          {
            success = false;
            value = null;
          };
      hasScopeValue = scopeEval.success;
      scopeValue = if hasScopeValue then scopeEval.value else null;
      hasOverrideScope = hasScopeValue && isAttrs scopeValue && scopeValue ? overrideScope;
      hasExtend = hasScopeValue && isAttrs scopeValue && scopeValue ? extend;

      # note that some scopes expose extend rather than overrideScope, e.g. haskellPackages
      # duck-typed, any prev attrset with overrideScope/extend matches
      # do not name a local dir after an extensible non-package-scope attr
      # (e.g. pkgs/lib would extend lib itself)
      isScope = hasScopeValue && isAttrs scopeValue && !isDerivation scopeValue && (hasOverrideScope || hasExtend);
      scopeOverride =
        if hasOverrideScope then
          scopeValue.overrideScope
        else
          scopeValue.extend;
    in
    if hasDefaultNix then
      let
        imported = import pkg;
      in
      # case 1: local package/default.nix always wins over currentPrev attrs
      if !isFunction imported then
        imported
      else
        callPackageWith callArgs pkg { }
    # case 2: the imported dir is an existing scope in currentPrev
    # i've decided that having a entry point for scoped pkgs to override arguments used is a antipattern
    # injecting root level pkgsPrev and pkgsFinal with scope level fixedpoints is a better idea
    else if isScope then
      scopeOverride
        (
          scopeFinal: scopePrev:
          # recurse:
          importPackagesTree {
            dir = pkg;
            currentFinal = scopeFinal;
            currentPrev = scopePrev;
            inheritedArgs = inheritedArgs // {
              "${name}Final" = scopeFinal;
              "${name}Prev" = scopePrev;
            };
          }
        )
    # case 3: local scope (no default.nix, but has child dirs with default.nix)
    else if hasChildScopes then
      makeScope callPackageWith
        (
          localScopeFinal:
          # recurse:
          importPackagesTree {
            dir = pkg;
            currentFinal = localScopeFinal;
            # a fresh local scope has nothing to override at this level
            # outer prev must not leak in or child names matching root attrs misroute to case 2
            currentPrev = { };
            inheritedArgs = inheritedArgs // {
              "${name}Final" = localScopeFinal;
              "${name}Prev" = localScopeFinal;
            };
          }
        )
    # bail if not scope and does not have default.nix
    else
      throw "path ${toString pkg} has no default.nix and is not a scope";
}
