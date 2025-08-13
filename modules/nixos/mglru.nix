{ lib, ... }:

{
  # https://docs.kernel.org/admin-guide/mm/multigen_lru.html
  boot.kernelPatches = lib.singleton {
    name = "mglru-config";
    patch = null;
    structuredExtraConfig = {
      LRU_GEN = lib.kernel.yes;
      LRU_GEN_ENABLED = lib.kernel.yes;
    };
  };
}
