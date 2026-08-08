{ inputs, stdenv }:

inputs.niks3.packages.${stdenv.hostPlatform.system}.niks3.overrideAttrs (prev: {
  src = inputs.niks3.outPath;
  vendorHash = "sha256-pwutQpIbvNesoHwpEBKYWnovwMvrTWvyAz/7QqSMrGI=";
})
