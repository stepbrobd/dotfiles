{ lib
, stdenvNoCC
, fetchzip
, autoPatchelfHook
, fixDarwinDylibNames
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "z3";
  version = "4.12.5";

  src = fetchzip {
    aarch64-darwin = {
      url = "https://github.com/z3prover/z3/releases/download/z3-${finalAttrs.version}/z3-${finalAttrs.version}-arm64-osx-11.0.zip";
      hash = "sha256-Dkrqjn56UIZcNYKDFZkn2QVLWou4Vf0NjKIITSsweeU=";
    };
    aarch64-linux = {
      url = "https://github.com/z3prover/z3/releases/download/z3-${finalAttrs.version}/z3-${finalAttrs.version}-arm64-glibc-2.35.zip";
      hash = "sha256-+kPQBHmKI7HyCp7oSFNAm321hXwyonSSVXTTvo4tVSA=";
    };
    x86_64-darwin = {
      url = "https://github.com/z3prover/z3/releases/download/z3-${finalAttrs.version}/z3-${finalAttrs.version}-x64-osx-11.7.10.zip";
      hash = "sha256-SfDKEz5p75HGM4lkyQUNPBnQZKtU9cTch6KkTeN94+E=";
    };
    x86_64-linux = {
      url = "https://github.com/z3prover/z3/releases/download/z3-${finalAttrs.version}/z3-${finalAttrs.version}-x64-glibc-2.31.zip";
      hash = "sha256-kHWanLxL180OPiDSvrxXjgyd/sKFHVgX5/SFfL+pJJs=";
    };
  }.${stdenvNoCC.system};

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ ]
    ++ lib.optional stdenvNoCC.isDarwin fixDarwinDylibNames
    ++ lib.optional stdenvNoCC.isLinux autoPatchelfHook;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/z3 $out/bin/z3

    runHook postInstall
  '';

  meta.mainProgram = "z3";
})
