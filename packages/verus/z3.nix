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
      url = "https://github.com/z3prover/z3/releases/download/z3-4.12.5/z3-4.12.5-arm64-osx-11.0.zip";
      hash = "sha256-Dkrqjn56UIZcNYKDFZkn2QVLWou4Vf0NjKIITSsweeU=";
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
