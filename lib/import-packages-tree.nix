{ lib }:

{ dir
, currentFinal
, currentPrev
, inheritedArgs ? { }
}:

let
  inherit (lib)
    baseNameOf
    callPackageWith
    childDirsWithDefault
    fix
    hasAttrByPath
    importPackagesTree
    isDerivation
    isFunction
    length
    makeScope
    mkDynamicAttrs
    pathExists
    ;
in
mkDynamicAttrs (
  fix (self: {
    inherit dir;
    fun =
      name:
      (
        # was importPackagesWith:
        # <resulting package set> :: <the file we are calling> :: <callPackage args>
        pkgs: pkg: args:
        let
          scopeName = baseNameOf pkg;
          hasScopeAttr = hasAttrByPath [ scopeName ] currentPrev;
          scopeValue = if hasScopeAttr then currentPrev.${scopeName} else null;
          hasOverrideScope = hasScopeAttr && hasAttrByPath [ scopeName "overrideScope" ] currentPrev;
          hasExtend = hasScopeAttr && hasAttrByPath [ scopeName "extend" ] currentPrev;

          hasDefaultNix = pathExists (pkg + "/default.nix");
          childScopeNames = if !hasDefaultNix then childDirsWithDefault pkg else [ ];
          hasChildScopes = length childScopeNames > 0;

          # note that some scopes expose extend rather than overrideScope, e.g. haskellPackages
          isScope = hasScopeAttr && !isDerivation scopeValue && (hasOverrideScope || hasExtend);
          scopeOverride =
            if hasOverrideScope then
              scopeValue.overrideScope
            else
              scopeValue.extend;
        in
        # case 1: the imported dir is an existing scope in currentPrev
          # i've decided that having a entry point for scoped pkgs to override arguments used
          # is a antipattern, injecting root level pkgsPrev and pkgsFinal with scope level
          # fixedpoints is a better idea
        if isScope then
          if hasDefaultNix then
            throw "scope ${scopeName} must not define default.nix"
          else
            scopeOverride (
              scopeFinal: scopePrev:
              let
                inheritedScopeArgs = inheritedArgs // {
                  "${scopeName}Final" = scopeFinal;
                  "${scopeName}Prev" = scopePrev;
                };
              in
              # recurse:
              importPackagesTree {
                dir = pkg;
                currentFinal = scopeFinal;
                currentPrev = scopePrev;
                inheritedArgs = inheritedScopeArgs;
              }
            )
        # case 2: local scope (no default.nix, but has child dirs with default.nix)
        else if !hasDefaultNix && hasChildScopes then
          makeScope callPackageWith
            (
              localScopeFinal:
              let
                inheritedScopeArgs = inheritedArgs // {
                  "${scopeName}Final" = localScopeFinal;
                  "${scopeName}Prev" = localScopeFinal;
                };
              in
              # recurse:
              importPackagesTree {
                dir = pkg;
                currentFinal = localScopeFinal;
                currentPrev = currentPrev;
                inheritedArgs = inheritedScopeArgs;
              }
            )
        # bail if not scope and does not have default.nix
        else if !hasDefaultNix then
          throw
            "path ${toString pkg} has no default.nix and is not a scope"
        else
          let
            imported = import pkg;
          in
          # case 3: the imported dir default.nix file is a flat attrset
          if !isFunction imported then
            imported
          # case 4: the imported dir default.nix is a derivation/function
          else
            (pkgs.lib.callPackageWith pkgs) pkg args
      )
        (
          # always expose top-level package args (e.g. fetchgit) and then scope args
          # (e.g. mkDerivation) with scope args taking precedence.
          (if hasAttrByPath [ "pkgsFinal" ] inheritedArgs then inheritedArgs.pkgsFinal else currentFinal)
          // currentFinal
          // inheritedArgs
        )
        (self.dir + "/${name}")
        { };
  })
)
