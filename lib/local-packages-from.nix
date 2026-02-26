{ lib }:

{ dir
, scope
}:

let
  inherit (lib)
    attrNames
    childDirsWithDefault
    filter
    genAttrs
    hasAttrByPath
    isAttrs
    length
    localPackagesFrom
    pathExists
    readDir
    ;

  entries = readDir dir;

  names =
    filter
      (
        name:
        let
          path = dir + "/${name}";
          isDir = entries.${name} == "directory";
          hasDefaultNix = isDir && pathExists (path + "/default.nix");
          childScopeNames = if isDir && !hasDefaultNix then childDirsWithDefault path else [ ];
          isNestedScope = isDir && !hasDefaultNix && length childScopeNames > 0;
        in
        isDir
        && hasAttrByPath [ name ] scope
        && (
          hasDefaultNix
          || (isNestedScope && isAttrs scope.${name})
        )
      )
      (attrNames entries);
in
genAttrs names (
  name:
  let
    path = dir + "/${name}";
  in
  if pathExists (path + "/default.nix") then
    scope.${name}
  else
    localPackagesFrom {
      dir = path;
      scope = scope.${name};
    }
)
