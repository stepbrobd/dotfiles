{ lib, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      legacyPackages = lib.localPackagesFrom {
        dir = ../../pkgs;
        scope = pkgs;
      };

      packages =
        lib.genAttrs
          # note that this is eager but i cant think of a better way to delay eval
          (lib.filter (p: lib.isDerivation pkgs.${p}) (lib.childDirsWithDefault ../../pkgs))
          (p: pkgs.${p});
    };
}
