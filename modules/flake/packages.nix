{ lib, ... }:

{
  perSystem =
    { pkgs, ... }:
    rec {
      legacyPackages = lib.localPackagesFrom {
        dir = ../../pkgs;
        scope = pkgs;
      };

      packages = legacyPackages;
    };
}
