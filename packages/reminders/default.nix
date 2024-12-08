{ lib
, stdenv
, apple-sdk_14
, fetchFromGitHub
, swift
, swiftpm
, swiftpm2nix
, swiftPackages
}:

let
  generated = swiftpm2nix.helpers ./generated;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "reminders";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "keith";
    repo = "reminders-cli";
    rev = finalAttrs.version;
    hash = "sha256-2pGt9qzafIPYVLVGUypvMgyF9El3N83X+AdL81NKgBo=";
  };

  configurePhase = generated.configure;

  nativeBuildInputs = [ swift swiftpm ];
  buildInputs = [ apple-sdk_14 swiftPackages.Foundation ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp $binPath/reminder $out/bin/
  '';

  meta = {
    broken = true;
    platforms = lib.platforms.darwin;
  };
})
