{ inputs, stdenv }:

inputs.miroir.packages.${stdenv.hostPlatform.system}.default
