{ lib
, callPackage
, stdenv
, apple-sdk
, makeRustPlatform
, rust-bin
, fetchFromGitHub
, git
, makeWrapper
, zlib
}:

let
  pname = "verus";
  version = "0.2025.07.07.b4e94d8";
  src = fetchFromGitHub {
    leaveDotGit = true;
    owner = "verus-lang";
    repo = "verus";
    tag = "release/rolling/${version}";
    hash = "sha256-GJGuQ1PExYETWUYfvD97OV5AIWnmn9cLy8MQGq9bcmg=";
  };

  rustToolchain = rust-bin.fromRustupToolchainFile "${src}/rust-toolchain.toml";
  rustPlatform = makeRustPlatform {
    cargo = rustToolchain;
    rustc = rustToolchain;
  };

  rustup = callPackage ./rustup.nix {
    toolchainName = "${rustToolchain.version}-${{
      x86_64-linux = "x86_64-unknown-linux-gnu";
      aarch64-linux = "aarch64-unknown-linux-gnu";
      x86_64-darwin = "x86_64-apple-darwin";
      aarch64-darwin = "aarch64-apple-darwin";
    }.${stdenv.system}}";
  };
  vargo = callPackage ./vargo.nix { };
  z3 = callPackage ./z3.nix { };
in
rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version src;

  sourceRoot = "source/source";

  cargoLock = {
    lockFile = "${src}/source/Cargo.lock";
    outputHashes = {
      "getopts-0.2.21" = "sha256-N/QJvyOmLoU5TabrXi8i0a5s23ldeupmBUzP8waVOiU=";
      "smt2parser-0.6.1" = "sha256-AKBq8Ph8D2ucyaBpmDtOypwYie12xVl4gLRxttv5Ods=";
      "synstructure-0.13.0" = "sha256-nluVB2uL8nSv3XPvxa2MsjRhSMoTybCKGiBqlshnnVU=";
    };
  };

  env.VERUS_Z3_PATH = lib.getExe z3;

  buildInputs = [ zlib ] ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk;

  nativeBuildInputs = [
    makeWrapper
    git
    rustup
    vargo
    z3
  ];

  buildPhase = ''
    runHook preBuild

    vargo build --release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ls -la

    mkdir -p $out/lib $out/bin
    cp -r target-verus/release $out/lib/verus-root
    ln -s ../lib/verus-root/cargo-verus $out/bin

    wrapProgram $out/lib/verus-root/verus \
      --prefix PATH : ${lib.makeBinPath [ rustup ]}

    runHook postInstall
  '';

  passthru = {
    inherit
      rustToolchain
      rustPlatform
      vargo
      z3
      ;
  };
})
