# https://github.com/NixOS/nixpkgs/issues/176536
# https://github.com/NixOS/nixpkgs/pull/289587

{ stdenv }:

(import
  (builtins.fetchTarball {
    url = "https://github.com/pca006132/nixpkgs/archive/llvm-bolt.tar.gz";
    sha256 = "0c9dav7i3gl6ycz9balfz7diydaxdz7z6dy9fl32jvcpfb7szvpp";
  })
  { inherit (stdenv) system; }).llvmPackages_18.bolt
