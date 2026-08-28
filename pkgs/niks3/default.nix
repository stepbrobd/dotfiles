{ inputs, stdenv }:

inputs.niks3.packages.${stdenv.hostPlatform.system}.niks3.overrideAttrs (prev: {
  src = inputs.niks3.outPath;
  vendorHash = "sha256-lql+r9+hy7XX9/aSezwweKSU/MphxvIkaT0gHf59fsc=";
})
