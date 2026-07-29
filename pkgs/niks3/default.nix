{ inputs, stdenv }:

inputs.niks3.packages.${stdenv.hostPlatform.system}.niks3.overrideAttrs (prev: {
  src = inputs.niks3.outPath;
  vendorHash = "sha256-qkB99S/9fmSk5G9uHyQF/z+joi9JACIJWaHMrIo4ziU=";
})
